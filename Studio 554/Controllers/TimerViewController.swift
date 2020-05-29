//
//  SecondViewController.swift
//  Studio 554
//
//  Created by Alex Luke on 5/27/20.
//  Copyright © 2020 Alex Luke. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var timePickerView: UIDatePicker!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var confirmButton: UIButton!
    
    var timerSetting: Date?
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.layer.cornerRadius = confirmButton.frame.size.height / 2
        
        // sets time picker and switch based on saved values
        if let swtichStatus = defaults.string(forKey: "timerSwitch") {
            if swtichStatus == "On" {
                timeSwitch.isOn = true
            } else {
                timeSwitch.isOn = false
            }
        }
        
        if let savedTimerSetting = defaults.object(forKey: "timer") {
            timePickerView.date = savedTimerSetting as! Date
        }
    }

    @IBAction func timerValueChanged(_ sender: UIDatePicker) {
        
        timerSetting = sender.date
        print("Interval since now: \(sender.date.timeIntervalSinceNow)")
        
    }
    
    @IBAction func timerToggled(_ sender: UISwitch) {
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        
        defaults.set(timerSetting, forKey: "timer")
        
        // if time switch on, sends delay time to Thingspeak. If switch is off, sets delay to 0.
        if timeSwitch.isOn {
            if let delayTime = timerSetting?.timeIntervalSinceNow {
                manager.setCommandDelay(delayTime)
                manager.writeDelayToChannel(delay: manager.commandDelay!)
                defaults.set("On", forKey: "timerSwitch")
            }
        } else {
            manager.setCommandDelay(0)
            manager.writeDelayToChannel(delay: manager.commandDelay!)
            defaults.set("Off", forKey: "timerSwitch")
        }
    }
}

