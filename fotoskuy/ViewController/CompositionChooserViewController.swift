//
//  CompositionChooserViewController.swift
//  fotoskuy
//
//  Created by Vivaldi Darren Christophilus on 08/04/22.
//

import UIKit

class CompositonChooserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var compositionTable: UITableView!
    
    var compositionCollections = [Composition]()
    
    var selectedRow = 0
    
    var selectedComposition = SingletonComposition.sharedInstance.composition
    
    @IBAction func dismissModal(_ sender: UIButton) {
//        let userInfo = ["selectedTimer" : selectedTimer]
//        NotificationCenter.default.post(name: Notification.Name("timer"), object: nil, userInfo: userInfo)
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedComposition.compositionName)
        
        addCompositionArray()

        selectedRow = checkCurrentIndex()
        
        print(selectedRow)
        
        compositionTable.register(UITableViewCell.self, forCellReuseIdentifier: "CompositionTableCell")
        compositionTable.delegate = self
        compositionTable.dataSource = self
    }
    
    private func addCompositionArray() {
        compositionCollections = initCompData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compositionCollections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCompositionEntry = compositionCollections[indexPath.row]
        selectedRow = indexPath.row
        
        compositionTable.reloadData()
        
        selectedComposition = selectedCompositionEntry
        SingletonComposition.sharedInstance.composition = selectedCompositionEntry
        
        let userInfo = ["selectedComposition" : selectedCompositionEntry]
        NotificationCenter.default.post(name: Notification.Name("composition"), object: nil, userInfo: userInfo)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = compositionTable.dequeueReusableCell(withIdentifier: "CompositionTableCell", for: indexPath)
        
        if indexPath.row == selectedRow {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = compositionCollections[indexPath.row].compositionName
        
        return cell
    }
    
    private func checkCurrentIndex() -> Int {
        var selectedIndex = 0
        for (index, composition) in compositionCollections.enumerated() {
            if composition.compositionName == selectedComposition.compositionName {
                selectedIndex = index
            }
        }
        return selectedIndex
    }
    
}

