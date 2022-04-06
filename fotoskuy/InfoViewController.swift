//
//  InfoViewController.swift
//  fotoskuy
//
//  Created by Elvina Jacia on 05/04/22.
//

import UIKit

class InfoViewController: UIViewController {

    public var position: Int = 0
    public var compositions: [Composition] = []
    @IBOutlet var holder : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 1 {
                configure()
        }
            
        func configure(){
        //set up player
                
                
        //set up user interface elements
            }
    }
    

 

}
