//
//  PlayerViewController.swift
//  fotoskuy
//
//  Created by Elvina Jacia on 06/04/22.
//


import UIKit

class InfoSheetViewController: UIViewController {

    @IBOutlet var holder : UIView!
    
    @IBOutlet weak var compositionName: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var compositionImageExample: UIImageView!
    
    @IBOutlet weak var compositionSubtitle: UITextView!
    
    @IBOutlet weak var compositionBodyText: UITextView!
    
    var composition: Composition = Composition(compositionName: "", compositionSubtitle: "", compositionBodyText: "", compositionImageName: "", compositionGridImageName: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCompositionInfo()
    }
  
    @IBAction func doneActionButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func configureCompositionInfo() {
        compositionName.text = composition.compositionName
        compositionSubtitle.text = composition.compositionSubtitle
        compositionBodyText.text = composition.compositionBodyText
    }

}
