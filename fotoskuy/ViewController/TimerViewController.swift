//
//  TimerViewController.swift
//  fotoskuy
//
//  Created by Michael Ricky on 08/04/22.
//

import UIKit

class TimerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var timerTable: UITableView!
    
    var timers: [Int] = [0, 3, 10]
    
    var selectedTimer = SingletonTimer.sharedInstance.timer
    var selectedRow = 0
    
    @IBAction func dismissModal(_ sender: UIButton) {
        let userInfo = ["selectedTimer" : selectedTimer]
        NotificationCenter.default.post(name: Notification.Name("timer"), object: nil, userInfo: userInfo)
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedRow = checkCurrentIndex()
        
        timerTable.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        timerTable.delegate = self
        timerTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTimerEntry = timers[indexPath.row]
        selectedRow = indexPath.row
        
        timerTable.reloadData()
        
        var currentSelectedTimer: TimerData!
        
        if selectedTimerEntry == 0 {
            currentSelectedTimer = TimerData(isTimerActive: false, timerAmount: 0)
        } else {
            currentSelectedTimer = TimerData(isTimerActive: true, timerAmount: selectedTimerEntry)
        }
        
        selectedTimer = currentSelectedTimer
        SingletonTimer.sharedInstance.timer = currentSelectedTimer
        
        let userInfo = ["selectedTimer" : selectedTimer]
        NotificationCenter.default.post(name: Notification.Name("timer"), object: nil, userInfo: userInfo)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timerTable.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        if indexPath.row == selectedRow {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Off"
        } else {
            cell.textLabel?.text = "\(String(self.timers[indexPath.row])) seconds"
        }
        
        return cell
    }
    
    private func checkCurrentIndex() -> Int {
        var selectedIndex = 0
        for (index, timer) in timers.enumerated() {
            if timer == selectedTimer.timerAmount {
                selectedIndex = index
                break
            }
        }
        
        return selectedIndex
    }
}
