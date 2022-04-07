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
    
    @IBOutlet weak var previewGallery: UIImageView!
    
    // Camera Frame
    @IBOutlet weak var photoFrame: UIView!
    
    // Shutter Button
    @IBAction func shutterButtonPressed(_ sender: UIButton) {
        capturePhoto()
    }
    
    @IBOutlet weak var flashButton: UIButton!
    
    @IBOutlet weak var timerButton: UIButton!
    
    @IBOutlet weak var flipButton: UIButton!
    
    @IBAction func infoPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToInfoSheet", sender: sender)
    }
    
    @IBAction func gridPressed(_ sender: UIButton) {
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
    }
    
    @IBAction func rotatePressed(_ sender: UIButton) {
    }
    
    @IBAction func focusAndExposeTap(_ sender: UITapGestureRecognizer) {
        let devicePoint = previewLayer.captureDevicePointConverted(fromLayerPoint: sender.location(in: sender.view))
        
        print(devicePoint)
        
        focus(with: .autoFocus, exposureMode: .autoExpose, at: devicePoint, monitorSubjectAreaChange: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        photoFrame.layer.addSublayer(previewLayer)
        checkCameraPermission()
        initCompositionArray()
        initDefaultComposition()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
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
                setUpCamera()
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
                    }
                }
            case .restricted:
                break
            case .denied:
                break
            case .authorized:
                setUpCamera()
            case .limited:
                break
        @unknown default:
                break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        
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
        let photoSettings = AVCapturePhotoSettings()
        
        photoSettings.flashMode = determineFlashMode()
        
        output.capturePhoto(with: photoSettings,
                            delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        
        let image = UIImage(data: data)
        
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        previewGallery?.image = image! as UIImage
    }
    
    private func initDefaultComposition() {
        self.currentComposition = compositionCollections[0]
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
}
