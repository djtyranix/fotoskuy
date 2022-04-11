//
//  SingletonTimer.swift
//  fotoskuy
//
//  Created by Michael Ricky on 08/04/22.
//

import Foundation

class SingletonTimer {
    var timer = TimerData(isTimerActive: false, timerAmount: 0)
    
    struct Static {
        static var instance: SingletonTimer?
    }
    
    class var sharedInstance: SingletonTimer {
        if Static.instance == nil {
            Static.instance = SingletonTimer()
        }
        
        return Static.instance!
    }
    
    func disposeSingleton() {
        SingletonTimer.Static.instance = nil
        print("SingletonTimer Disposed")
    }
}
