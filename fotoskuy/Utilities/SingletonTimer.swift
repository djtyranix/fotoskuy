//
//  SingletonTimer.swift
//  fotoskuy
//
//  Created by Michael Ricky on 08/04/22.
//

import Foundation

class SingletonTimer {
    var timer = TimerData(isTimerActive: false, timerAmount: 0)
    
    static let sharedInstance = SingletonTimer()
    
    private init() {
        
    }
}
