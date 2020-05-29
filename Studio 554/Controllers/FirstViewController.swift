//
//  FirstViewController.swift
//  Studio 554
//
//  Created by Alex Luke on 5/27/20.
//  Copyright © 2020 Alex Luke. All rights reserved.
//

import UIKit

var model = ClimateControlModel()
var manager = ClimateControlManager()

class FirstViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var thermometerImage: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var heaterSwitch: UISwitch!
    @IBOutlet weak var acSwitch: UISwitch!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.requestChannelFeed(field: 1)
        manager.requestChannelFeed(field: 2)
        manager.requestChannelFeed(field: 3)
        
        confirmButton.layer.cornerRadius = confirmButton.frame.size.height / 2
        
        while (!model.tempUpdated || !model.acUpdated || !model.heaterUpdated) {
            print("waiting for network response...")
        }
        
        temperatureLabel.text = "\(model.roomTemp)° F"
        updateThermometerImage(temperature: model.roomTemp)
        updateSwitches()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        manager.requestChannelFeed(field: 1)
        temperatureLabel.text = "\(model.roomTemp)° F"
        updateThermometerImage(temperature: model.roomTemp)
        
    }

    @IBAction func heaterToggled(_ sender: UISwitch) {
        
        if sender.isOn {
            model.heaterIsOn = true
            print("heater switched to on")
        } else {
            model.heaterIsOn = false
            print("heater switched to off")
        }
    }
    
    @IBAction func acToggled(_ sender: UISwitch) {
        if sender.isOn {
            model.acIsOn = true
            print("ac switched to on")
        } else {
            model.acIsOn = false
            print("ac switched to off")
        }
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        if model.heaterIsOn {
            if model.acIsOn {
                presentWarningAlert(title: "Can't have both heat and AC on!")
            } else {
                manager.addTalkbackCommand("HEAT_ON")
                presentWarningAlert(title: "Turning on heater!")
            }
        } else if model.acIsOn {
            manager.addTalkbackCommand("AC_ON")
            presentWarningAlert(title: "Turning on A/C!")
        } else {
            manager.addTalkbackCommand("SYSTEM_OFF")
            presentWarningAlert(title: "Turning system off!")
        }
    }
    
    func updateThermometerImage(temperature: Int) {
        if temperature < 58 {
            thermometerImage.image = UIImage(systemName: "thermometer.snowflake")
            thermometerImage.tintColor = UIColor.systemTeal
            
        } else if temperature > 80 {
            thermometerImage.image = UIImage(systemName: "thermometer.sun")
            thermometerImage.tintColor = UIColor.systemRed
        } else {
            thermometerImage.image = UIImage(systemName: "thermometer")
            thermometerImage.tintColor = UIColor.black
        }
    }
    
    func updateSwitches() {
        
        if model.heaterIsOn {
            heaterSwitch.isOn = true
        } else {
            heaterSwitch.isOn = false
        }
        
        if model.acIsOn {
            acSwitch.isOn = true
        } else {
            acSwitch.isOn = false
        }
    }
    
    func presentWarningAlert(title: String, message: String = "") {
       
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
           
            // what will happen when user clicks "OK" button.
        }
    
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

