//
//  ViewController.swift
//  fotoskuy
//
//  Created by Michael Ricky on 04/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var previewGallery: UIImageView!
    
    @IBAction func shutterButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func infoPressed(_ sender: UIButton) {
    }
    
    @IBAction func gridPressed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
}

