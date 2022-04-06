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
    
    // Chosen Composition
    var currentComposition: Composition!
    
    // Composition Array
    var compositionCollections = [Composition]()
    
    @IBOutlet weak var previewGallery: UIImageView!
    
    // Camera Frame
    @IBOutlet weak var photoFrame: UIView!
    
    // Shutter Button
    @IBAction func shutterButtonPressed(_ sender: UIButton) {
        capturePhoto()
    }
    
    @IBAction func infoPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToInfoSheet", sender: sender)
    }
    
    @IBAction func gridPressed(_ sender: UIButton) {
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
    
    private func initDefaultComposition() {
        self.currentComposition = compositionCollections[4]
    }
    
    private func initCompositionArray() {
        compositionCollections.append(
            Composition(compositionName: "Rule of Thirds",
                        compositionSubtitle: "The Rule of Thirds brings focus and balance to your landscape shots.",
                        compositionBodyText: "The Rule of Thirds places your subject on the left-third or right-third of the frame. This photo, by adventure photographer Jimmy Chin, uses the Rule of Thirds, where the main subject is positioned along the right vertical-third line.\n\nCreate a sense of expansiveness by positioning the horizon line along the lower third of the grid, drawing the viewer's eye to the sky above.\n\nPosition the horizon along the upper third to draw the eye to the foreground to create a sense of proximity with the landscape.\n\nPlace an interesting natural feature—a mountain peak or waterfall—on one of the four intersection points to create a focal point.",
                        compositionImageName: "RuleOfThirds",
                        compositionGridImageName: "RuleOfThirdsGrid")
        )
        
        compositionCollections.append(
            Composition(compositionName: "Golden Ratio",
                        compositionSubtitle: "Golden Ratio leads viewers eyes through an image with a natural flow.",
                        compositionBodyText: "it’s an excellent technique to use when you have a single subject in a wide-angle shot or a single focal point in a landscape.\n\nYou could try to place your subject at the very end of the spiral for the best composition.The spiral works by focusing the viewer’s eye on the end of the spiral and then leading them outwards to the whole scene.\n\nThe great thing about the spiral is that it works from all angles. You can mirror the original spiral, flip it upside down or place it in any direction.\n\nIf your scene full of straight objects or line, don't try to force them in to the spiral, and consider using the Golden Section (phi grid) instead.",
                        compositionImageName: "GoldenRatio",
                        compositionGridImageName: "GoldenRatioGrid")
        )
        
        compositionCollections.append(
            Composition(compositionName: "Golden Triangle",
                        compositionSubtitle: "Golden Triangle rule is a series of diagonal lines that form right-angle triangles act as a composition guide.",
                        compositionBodyText: "Golden triangle photography is a composition technique used in photography. According to the golden triangle rule, a frame is divided into four triangles by drawing a diagonal line and the perpendicular bisectors of this line from the other two corners of the frame. To follow this composition rule, the subjects/area of interest must fall on the two points of intersection or these three lines or inside these triangles.\n\nThe main subject of the photo should sit on the intersection of these triangles.\n\nYou can use the main diagonal line or the two perpendicular bisectors as the leading lines to the subject of interest.\n\nPut the subject in the picture can be inside these triangles to make the frame aesthetically more pleasing.",
                        compositionImageName: "GoldenTriangle",
                        compositionGridImageName: "GoldenTriangleGrid")
        )
        
        compositionCollections.append(
            Composition(compositionName: "Golden Section (Phi Grid)",
                        compositionSubtitle: "The phi grid is another way to visualize the golden ratio.",
                        compositionBodyText: "Rectangles can be superimposed over an image in a grid based on the 1:1.618 ratio. This “phi grid” divides your scene into thirds, both horizontally and vertically. But unlike the more popular rule of thirds, the center lines in the Phi Grid are closer together.\n\nYou can see when using the Phi Grid is in the spaces where gridlines intersect. These so-called “sweet spots” are places where the eye is naturally drawn in an image.\n\nWhen framing on the Phi Grid you can put the subject remains the center of affection by keeping it centralized.\n\nAligning an image so that key parts fall in these areas will create focus and harmony. The phi grid is best suited for photographs with many lines in them",
                        compositionImageName: "GoldenSection",
                        compositionGridImageName: "GoldenSectionGrid")
        )
        
        compositionCollections.append(
            Composition(compositionName: "Symmetrical Line",
                        compositionSubtitle: "Symmetrical Line helps to achive same weight and give a perfect balance between two sides in photo.",
                        compositionBodyText: "Symmetry appears when parts of your composition mirror other parts. It is created when two halves of your scene look the same and balance each other out. Symmetry defines something being clean, proportional and balanced and will make pictures appear neat, tidy and clinical.\n\nFor perfect symmetry. Create an image that is centered on a point in the middle, around which everything else radiates. This is possible if your subject is symmetrical from side to side, or from top to bottom. Using the center as a focal point will allow you to create a dramatic, if unsettling, image.\n\nPosition your focal point along one of the lines or on one of the four intersections. This naturally places the point of focus off-center, creating aesthetically pleasing images through asymmetry.",
                        compositionImageName: "SymmetricalLine",
                        compositionGridImageName: "SymmetricalLineGrid")
        )
        
        compositionCollections.append(
            Composition(compositionName: "Diagonal Line",
                        compositionSubtitle: "To be updated.",
                        compositionBodyText: "To be updated.",
                        compositionImageName: "DiagonalLine",
                        compositionGridImageName: "DiagonalLineGrid")
        )
        
        compositionCollections.append(
            Composition(compositionName: "Off",
                        compositionSubtitle: "Off",
                        compositionBodyText: "Off",
                        compositionImageName: "Off",
                        compositionGridImageName: "Off")
        )
    }
}

