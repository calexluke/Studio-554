//
//  SecondViewController.swift
//  Studio 554
//
//  Created by Alex Luke on 5/27/20.
//  Copyright © 2020 Alex Luke. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    

    @IBOutlet weak var commandPickerView: UIPickerView!
    @IBOutlet weak var timePickerView: UIDatePicker!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var confirmButton: UIButton!
    
    var timerSetting: Date?
    var commandPickerSetting = 0
    let defaults = UserDefaults.standard
    var pickerOptions = [String]()
    let talkBackCommands = ["HEAT_ON", "AC_ON", "SYSTEM_OFF"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commandPickerView.dataSource = self
        commandPickerView.delegate = self
        confirmButton.layer.cornerRadius = confirmButton.frame.size.height / 2
        
        pickerOptions = ["Turn On Heater",
                             "Turn On A/C",
                             "Turn Off System"]
        
        // sets time picker and switch based on saved values
        updateUIWithDefaults()
        
    }

    @IBAction func timerValueChanged(_ sender: UIDatePicker) {
        
        timerSetting = sender.date
        print("Interval since now: \(sender.date.timeIntervalSinceNow)")
        
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        
        setDefaults()
        var message: String
        let command = talkBackCommands[commandPickerSetting]
        
        // if time switch on, sends delay time to Thingspeak. If switch is off, sets delay to 0.
        if timeSwitch.isOn {
            if let delayTime = timerSetting?.timeIntervalSinceNow {
                manager.setCommandDelay(delayTime)
                manager.writeDelayToChannel(delay: manager.commandDelay!)
            }
        } else {
            manager.setCommandDelay(0)
            manager.writeDelayToChannel(delay: manager.commandDelay!)
        }
        
        // checks whether data was successfully posted. Need to update timing with this.
        while manager.gotThingSpeakResponse == false {
            print("Waiting for thingspeak response...")
        }
        
        if manager.thingSpeakResponse == "0" {
            message = "ThingSpeak only accepts posts every 15 seconds. Please try again soon!"
        } else {
            message = "Timer set!"
            manager.addTalkbackCommand(command)
        }
        
        presentWarningAlert(title: message)
        manager.gotThingSpeakResponse = false
    }
    
    //MARK: - user defaults
    func setDefaults() {
        
        defaults.set(timerSetting, forKey: "timer")
        defaults.set(commandPickerSetting, forKey: "pickerSetting")
        
        if timeSwitch.isOn {
            defaults.set("On", forKey: "timerSwitch")
        } else {
            defaults.set("Off", forKey: "timerSwitch")
        }
    }
    
    func updateUIWithDefaults() {
        
        if let swtichStatus = defaults.string(forKey: "timerSwitch") {
            if swtichStatus == "On" {
                timeSwitch.isOn = true
            } else {
                timeSwitch.isOn = false
            }
        }
        
        if let savedTimerSetting = defaults.object(forKey: "timer") {
            timePickerView.setDate(savedTimerSetting as! Date, animated: true)
        }
        
        let savedRow = defaults.integer(forKey: "pickerSetting")
        commandPickerView.selectRow(savedRow, inComponent: 0, animated: true)
    }
    
    //MARK: - pickerView methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print("setting command picker setting to \(pickerOptions[row])")
        commandPickerSetting = row
    }
}

