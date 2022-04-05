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
    
    @IBOutlet weak var previewGallery: UIImageView!
    
    // Camera Frame
    @IBOutlet weak var photoFrame: UIView!
    
    // Shutter Button
    @IBAction func shutterButtonPressed(_ sender: UIButton) {
        capturePhoto()
    }
    
    @IBAction func infoPressed(_ sender: UIButton) {
    }
    
    @IBAction func gridPressed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        photoFrame.layer.addSublayer(previewLayer)
        checkCameraPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = photoFrame.bounds
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
            } catch {
                print(error)
            }
        }
    }
    
    private func capturePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(),
                            delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        
        let image = UIImage(data: data)
        
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
}

