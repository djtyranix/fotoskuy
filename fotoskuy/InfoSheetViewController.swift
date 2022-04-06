//
//  InfoSheetViewController.swift
//  fotoskuy
//
//  Created by Elvina Jacia on 05/04/22.
//

import UIKit
//array obj
var compositions = [Composition]()

class InfoSheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configComposition()
        table.delegate = self
        table.dataSource = self
    }
    
    func configComposition(){
        compositions.append(Composition(compName: "Golden Ratio", compImgName: "GoldenRatioExample", compDesc: " DESCC BELOM "))
        
        compositions.append(Composition(compName: "Golden Triangle", compImgName: "GoldenTriangleExample", compDesc: " DESCC BELOM "))
        
        compositions.append(Composition(compName: "Golden Section", compImgName: "GoldenSectionExample", compDesc: " DESCC BELOM "))
        
        compositions.append(Composition(compName: "Rule of Third", compImgName: "RuleOfThirdExample", compDesc: " DESCC BELOM "))
        
        compositions.append(Composition(compName: "Symmetrical Line", compImgName: "SymmetricalLineExample", compDesc: " DESCC BELOM "))
        
        
        compositions.append(Composition(compName: "Diagonal Line", compImgName: "DiagonalLineExample", compDesc: " DESCC BELOM "))
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compositions.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cells", for: indexPath)
        let composition = compositions[indexPath.row]
        
        //config
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont(name: "San Francisco" , size: 20)
        //
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let position = indexPath.row
        
        guard let ivc = storyboard?.instantiateViewController(identifier: "compinfo") as? InfoViewController else {
            return
        }
        
        ivc.compositions = compositions
        ivc.position = position
        present(ivc, animated: true)
        
        
    }

}

//obj
struct Composition {
    let compName : String
    let compImgName : String
    let compDesc : String
}


