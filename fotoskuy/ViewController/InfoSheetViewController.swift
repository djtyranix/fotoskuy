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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        if holder.subviews.count == 1{
//            configure()
//    }
//        func configure(){
//            
//        }
//      
//    }
 
  
    @IBAction func doneActionButton(_ sender: Any) {
        dismiss(animated: true)
    }
    


}
