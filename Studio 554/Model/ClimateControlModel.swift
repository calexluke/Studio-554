//
//  climateControlModel.swift
//  Studio 554
//
//  Created by Alex Luke on 5/27/20.
//  Copyright © 2020 Alex Luke. All rights reserved.
//

import Foundation

struct ClimateControlModel {
    
    var roomTemp: Int = 50
    var heaterIsOn: Bool = false
    var acIsOn: Bool = false
    var tempUpdated: Bool = false
    var heaterUpdated: Bool = false
    var acUpdated: Bool = false
    
    mutating func updateTemperature(with temperatureString: String) {
        roomTemp = Int(Float(temperatureString)!)
        tempUpdated = true
        print("setting temperature to \(roomTemp) degrees")
    }
    
    mutating func updateSystemStatus(_ system: String, status: String) {
        
        if system == "Heater" {
            if status == "1" {
                heaterIsOn = true
            } else {
                heaterIsOn = false
            }
            heaterUpdated = true
            
        } else if system == "AC" {
            if status == "1" {
                acIsOn = true
            } else {
                acIsOn = false
            }
            acUpdated = true
        }
    }
    
    mutating func toggleSystem(_ appliance: String) {
        
        if appliance == "heater" {
            if heaterIsOn == false {
                heaterIsOn = true
            } else {
                heaterIsOn = false
            }
        }
        
        if appliance == "ac" {
            if acIsOn == false {
                acIsOn = true
            } else {
                acIsOn = false
            }
        }
    }
    
  
    
}
