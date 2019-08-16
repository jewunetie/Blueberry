//
//  timeStruct.swift
//  bluest_of_berries
//
//  Created by Kevin Alfaro on 7/29/19.
//  Copyright © 2019 Serene Saldana. All rights reserved.
//

import Foundation

// Struct (or class) this allows us to create instances of this object
struct Time {
    // made a private var called totalSeconds, initialized to 0
    private var totalSeconds: Int = 0
    // this function assures that the value passed is valid and not less than 0
    private mutating func isValidValue(_ newValue: Int) -> Int {
        if newValue < 0 {
            return 0
        } else {
            return newValue
        }
    }
    
    // our initializer function that is called always,
    init (_ minute: Int = 0, _ second: Int = 0) {
        totalSeconds = second >= 0 ? second : 0
        totalSeconds += minute >= 0 ? minute * 60 : 0
    }
    
    
    //we declare a var called seconds of type int
    var seconds: Int {
        get {
            // this method returns total seconds
            return totalSeconds - (minutes * 60)
        }
        set {
            // we set totalSeconds to the check of the new value
            totalSeconds = isValidValue(newValue)
        }
    }
    
    var minutes: Int {
        get {
            // returns the integer, whole number
            return totalSeconds / 60
        }
        
        set {
            // we set totalSeconds
            totalSeconds = isValidValue(newValue * 60)
        }
    }
    
    
    
    
    // PUBLIC FUNCTIONS:
    //
    mutating func changeSeconds(_ by: Int = 0) {
        totalSeconds = isValidValue(totalSeconds + by)
    }
    
    func timeString() -> String {
        let minStr: String = String(minutes)
        let secStr: String = String(seconds)
        var timeStr: String = minStr + ":"
        if seconds / 10 == 0 {
            timeStr += "0"
        }
        timeStr += secStr
        return timeStr
    }
}
