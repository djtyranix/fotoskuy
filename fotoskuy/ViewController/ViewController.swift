//
//  ViewController.swift
//  fotoskuy
//
//  Created by Michael Ricky on 04/04/22.
//

import AVFoundation
import Photos
import UIKit

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // Capture Session
    var session: AVCaptureSession?
    
    // Photo Output
    let output = AVCapturePhotoOutput()
    
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    // Video Device Input
    var videoDeviceInput: AVCaptureDeviceInput!
    
    // Chosen Composition
    var currentComposition: Composition!
    
    // Composition Array
    var compositionCollections = [Composition]()
    
    // Flash Mode
    var flashMode = 0 // Auto = 0, On = 1, Off = 2
    
    // Timer Selection
    var timerDuration = 0
    var timerCounter = 0
    var selectedTimer: TimerData!
    var timer: Timer!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var previewGallery: UIImageView!
    
    // Camera Frame
    @IBOutlet weak var photoFrame: UIView!
    
    // Shutter Button
    @IBAction func shutterButtonPressed(_ sender: UIButton) {
        if timerDuration == 0 {
            capturePhoto()
        } else {
            timerCounter = timerDuration
            timerLabel.text = String(timerCounter)
            timerLabel.alpha = 1
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerlabel), userInfo: nil, repeats: true)
        }
    }
    @IBOutlet weak var gridOverlay: UIImageView!
    
    @IBOutlet weak var flashButton: UIButton!
    
    @IBOutlet weak var timerButton: UIButton!
    
    @IBOutlet weak var flipButton: UIButton!
    
    @IBOutlet weak var gridButton: UIButton!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBAction func infoPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToInfoSheet", sender: sender)
    }
    
    @IBAction func gridPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CompositionChooser", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "compositionChooser")
        
        if let presentationController = viewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.large()]
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateComposition(notification:)), name: Notification.Name("composition"), object: nil)
        
        self.present(viewController, animated: true)
    }
    
    @IBAction func flashPressed(_ sender: UIButton) {
        switch flashMode {
        case 0:
            flashMode = 1
            flashButton.tintColor = UIColor(hex: "#A5FF00FF")
        case 1:
            flashMode = 2
            flashButton.tintColor = UIColor(hex: "#8E8D94FF")
        case 2:
            flashMode = 0
            flashButton.tintColor = .white
        default:
            flashMode = 0
            flashButton.tintColor = .white
        }
    }
    
    @IBAction func timerPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Timer", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "timerView")
        
        if let presentationController = viewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimer(notification:)), name: Notification.Name("timer"), object: nil)
        
        self.present(viewController, animated: true)
    }
    
    @IBAction func rotatePressed(_ sender: UIButton) {
        flipOrRotateGrid()
    }
    
    @IBAction func focusAndExposeTap(_ sender: UITapGestureRecognizer) {
        let devicePoint = previewLayer.captureDevicePointConverted(fromLayerPoint: sender.location(in: sender.view))
        
        focus(with: .continuousAutoFocus, exposureMode: .continuousAutoExposure, at: devicePoint, monitorSubjectAreaChange: true)
    }
    
    @IBAction func previewPressed(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "goToGallery", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timerLabel.alpha = 0
        
        photoFrame.layer.addSublayer(previewLayer)
        checkCameraPermission()
        initCompositionArray()
        initDefaultComposition()
        checkIfFlipGridSupported()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all //return the value as per the required orientation
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let videoPreviewLayerConnection = previewLayer.connection {
            let deviceOrientation = UIDevice.current.orientation
            guard let newVideoOrientation = AVCaptureVideoOrientation(rawValue: deviceOrientation.rawValue),
                deviceOrientation.isPortrait || deviceOrientation.isLandscape else {
                    return
            }
            
            videoPreviewLayerConnection.videoOrientation = newVideoOrientation
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = photoFrame.bounds
        previewLayer.masksToBounds = true
        previewLayer.cornerRadius = 8
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "goToInfoSheet" else {
            return
        }
        
        let vc = segue.destination as! InfoSheetViewController
        vc.composition = currentComposition
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                // Requesting Camera Permission
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    guard granted else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.checkPhotoLibraryPermission()
                    }
                }
            case .restricted:
                break
            case .denied:
                break
            case .authorized:
                checkPhotoLibraryPermission()
            @unknown default:
                break
        }
    }
    
    private func checkPhotoLibraryPermission() {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { granted in
                    guard granted == PHAuthorizationStatus.authorized else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.setUpCamera()
                        self.startPhotoCaching()
                    }
                }
            case .restricted:
                break
            case .denied:
                break
            case .authorized:
                setUpCamera()
                startPhotoCaching()
            case .limited:
                break
        @unknown default:
                break
        }
    }
    
    private func startPhotoCaching() {
        DispatchQueue.global(qos: .background).async {
            let imgManager = PHCachingImageManager()
            var phAssetArray = [PHAsset]()
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .opportunistic
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            for i in 0..<fetchResult.count {
                phAssetArray.append(fetchResult.object(at: i))
            }
            
            print("Starting photo caching")
            imgManager.startCachingImages(for: phAssetArray, targetSize: CGSize(width: 512, height: 512), contentMode: .aspectFill, options: requestOptions)
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        session.sessionPreset = .photo
        
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
                self.videoDeviceInput = input
            } catch {
                print(error)
            }
        }
    }
    
    private func capturePhoto() {
        var currentDevice: UIDevice
        currentDevice = .current
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        var deviceOrientation: UIDeviceOrientation
        deviceOrientation = currentDevice.orientation
        
        var imageOrientation: AVCaptureVideoOrientation!
        
        if deviceOrientation == .portrait {
            imageOrientation = .portrait
        } else if deviceOrientation == .landscapeLeft {
            imageOrientation = .landscapeRight
        } else if deviceOrientation == .landscapeRight {
            imageOrientation = .landscapeLeft
        } else if deviceOrientation == .portraitUpsideDown {
            imageOrientation = .portraitUpsideDown
        } else {
            imageOrientation = .portrait
        }
        
        if let photoOutputConnection = self.output.connection(with: .video) {
            photoOutputConnection.videoOrientation = imageOrientation
        }
        
        let photoSettings = AVCapturePhotoSettings()
        
        photoSettings.flashMode = determineFlashMode()
        
        output.capturePhoto(with: photoSettings,
                            delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        DispatchQueue.main.async {
            self.photoFrame.alpha = 0
            
            UIView.animate(withDuration: 0.25) {
                self.photoFrame.alpha = 1
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        
        let image = UIImage(data: data)!
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.previewGallery.alpha = 0
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.previewGallery.alpha = 1
                self.previewGallery?.image = image as UIImage
            }
        }
    }
    
    private func initDefaultComposition() {
        self.currentComposition = compositionCollections[0]
        
        gridOverlay.alpha = 1
        gridButton.tintColor = .white
        infoButton.tintColor = .white
        infoButton.isEnabled = true
        
        gridOverlay.image = UIImage(named: currentComposition.compositionGridImageName)
    }
    
    private func initCompositionArray() {
        compositionCollections = initCompData()
    }
    
    private func focus(with focusMode: AVCaptureDevice.FocusMode,
                       exposureMode: AVCaptureDevice.ExposureMode,
                       at devicePoint: CGPoint,
                       monitorSubjectAreaChange: Bool) {
        let device = videoDeviceInput.device
        
        do {
            try device.lockForConfiguration()
            
            if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(focusMode) {
                device.focusMode = focusMode
                device.focusPointOfInterest = devicePoint
            }
            
            if (device.isExposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode)) {
                device.exposureMode = exposureMode
                device.exposurePointOfInterest = devicePoint
            }
            
            device.isSubjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange
            device.unlockForConfiguration()
        } catch {
            print("Could not lock device for configuration: \(error)")
        }
    }
    
    private func determineFlashMode() -> AVCaptureDevice.FlashMode {
        switch flashMode {
        case 0:
            return .auto
        case 1:
            return .on
        case 2:
            return .off
        default:
            return .auto
        }
    }
    
    @objc private func updateTimer(notification: NSNotification) {
        let receivedData = notification.userInfo
        if let selectedTimer = receivedData!["selectedTimer"] as? TimerData {
            let isActive = selectedTimer.isTimerActive
            
            if isActive {
                timerButton.tintColor = UIColor(hex: "#A5FF00FF")
            } else {
                timerButton.tintColor = .white
            }
            
            timerDuration = selectedTimer.timerAmount
            self.selectedTimer = selectedTimer
        }
    }
    
    @objc private func updateTimerlabel() {
        print("Timer Activated")
        timerCounter -= 1
        
        if timerCounter > 0 {
            timerLabel.text = String(timerCounter)
        } else if timerCounter == 0 {
            timerLabel.alpha = 0
            capturePhoto()
            self.timer.invalidate()
        }
    }
    
    @objc private func updateComposition(notification: NSNotification) {
        let receivedData = notification.userInfo
        if let selectedComposition = receivedData!["selectedComposition"] as? Composition {
            if selectedComposition.compositionName == "Off" {
                gridOverlay.alpha = 0
                gridButton.tintColor = UIColor(hex: "#8E8D94FF")
                infoButton.tintColor = UIColor(hex: "#8E8D94FF")
                infoButton.isEnabled = false
            } else {
                gridOverlay.alpha = 1
                gridButton.tintColor = .white
                infoButton.tintColor = .white
                infoButton.isEnabled = true
                
                gridOverlay.image = UIImage(named: selectedComposition.compositionGridImageName)
            }
            
            self.currentComposition = selectedComposition
            checkIfFlipGridSupported()
        }
    }
    
    private func checkIfFlipGridSupported() {
        if currentComposition.compositionImageName == "GoldenSpiral" || currentComposition.compositionImageName == "GoldenTriangle" {
            flipButton.isEnabled = true
        } else {
            flipButton.isEnabled = false
        }
    }
    
    private func flipOrRotateGrid() {
        if currentComposition.compositionImageName == "GoldenSpiral" {
            switch currentComposition.compositionGridImageName {
            case "GoldenSpiralGrid":
                currentComposition.compositionGridImageName = "GoldenSpiralGrid1"
                gridOverlay.image = UIImage(named: currentComposition.compositionGridImageName)
            case "GoldenSpiralGrid1":
                currentComposition.compositionGridImageName = "GoldenSpiralGrid2"
                gridOverlay.image = UIImage(named: currentComposition.compositionGridImageName)
            case "GoldenSpiralGrid2":
                currentComposition.compositionGridImageName = "GoldenSpiralGrid3"
                gridOverlay.image = UIImage(named: currentComposition.compositionGridImageName)
            case "GoldenSpiralGrid3":
                currentComposition.compositionGridImageName = "GoldenSpiralGrid"
                gridOverlay.image = UIImage(named: currentComposition.compositionGridImageName)
            default:
                currentComposition.compositionGridImageName = "GoldenSpiralGrid"
                gridOverlay.image = UIImage(named: currentComposition.compositionGridImageName)
            }
        }
        
        if currentComposition.compositionImageName == "GoldenTriangle" {
            switch currentComposition.compositionGridImageName {
            case "GoldenTriangleGrid":
                currentComposition.compositionGridImageName = "GoldenTriangleGrid1"
                gridOverlay.image = UIImage(named: currentComposition.compositionGridImageName)
            case "GoldenTriangleGrid1":
                currentComposition.compositionGridImageName = "GoldenTriangleGrid"
                gridOverlay.image = UIImage(named: currentComposition.compositionGridImageName)
            default:
                currentComposition.compositionGridImageName = "GoldenTriangleGrid"
                gridOverlay.image = UIImage(named: currentComposition.compositionGridImageName)
            }
        }
    }
}
