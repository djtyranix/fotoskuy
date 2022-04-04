//
//  ViewController.swift
//  fotoskuy
//
//  Created by Michael Ricky on 04/04/22.
//

import UIKit

class ViewController: UIViewController {

    let altTitle: String = "My name is Michael, you know."
    let helloWorld: String = "Hello, World!"
    let h: String = "Hello"
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBAction func btnClickMe(_ sender: UIButton) {
        replaceTitle(title: helloWorld)
    }
    
    @IBAction func btnClickThis(_ sender: UIButton) {
        replaceTitle(title: altTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func replaceTitle(title: String) {
        labelTitle.text = title
    }


}

