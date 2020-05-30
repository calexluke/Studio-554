//
//  NetworkingManager.swift
//  Studio 554
//
//  Created by Alex Luke on 5/28/20.
//  Copyright © 2020 Alex Luke. All rights reserved.
//

import Foundation

class ClimateControlManager {
    
    var commandDelay: Int?
    var thingSpeakResponse = "0"
    var gotThingSpeakResponse: Bool = false

    func setCommandDelay(_ delay: Double) {
        
        // if selected date is earler than now (negative), shift it forward 24 hours (in seconds)
        if delay < 0.0 {
            let adjustedDelay = Int(delay + 86400.00)
            commandDelay = adjustedDelay
        } else {
            commandDelay = Int(delay)
        }
    }
    
    func requestChannelFeed(field: Int) {
        
        // field refers to data streams in the thingspeak channel. field 1 is temperature data, field 2 and 3 are heater and ac status
        
        let urlString = "https://api.thingspeak.com/channels/1067747/fields/\(field)/last.txt?api_key=\(constants.readAPIKey)"
    
        // Four steps for networking:
            // 1. Create a URL object
            if let url = URL(string: urlString) {
                
                // 2. Create a URL session
                let session = URLSession(configuration: .default)
            
                // 3.Give the session a task. Handler method is replaced using trailing closure syntax
                let task = session.dataTask(with: url) { (data, response, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let safeData = data {
                        let responseString = String(data: safeData, encoding: .utf8)!
            
                        if field == 1 {
                            model.updateTemperature(with: responseString)
                        } else if field == 2 {
                            model.updateSystemStatus("Heater", status: responseString)
                        } else if field == 3 {
                            model.updateSystemStatus("AC", status: responseString)
                        }
                    }
                }
                // 4. Start the task
                task.resume()
            }
        }
    
    func writeDelayToChannel(delay: Int) {
        
        let urlString = "https://api.thingspeak.com/update?api_key=\(constants.writeAPIKey)&field4=\(delay)"
                if let url = URL(string: urlString) {
                    let session = URLSession(configuration: .default)
                    let task = session.dataTask(with: url) { (data, response, error) in
                        
                        if error != nil {
                            print(error!)
                            return
                        }
                        if let safeData = data {
                            let responseString = String(data: safeData, encoding: .utf8)!
                
                            if responseString == "0" {
                                print("Failed to update ThingSpeak Channel with delay time")
                                self.thingSpeakResponse = responseString
                                self.gotThingSpeakResponse = true
                            } else {
                                print("added a command delay of \(delay) seconds to ThingSpeak Channel")
                                self.thingSpeakResponse = responseString
                                self.gotThingSpeakResponse = true
                            }
                        }
                    }
                    task.resume()
                }
    }
    
    func addTalkbackCommand (_ command: String) {
        
        // deletes earlier commands
        deleteTalkbackCommands()
        
        // Prepare URL
        let url = URL(string: "https://api.thingspeak.com/talkbacks/38797/commands.json")
        guard let requestUrl = url else { fatalError() }

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "api_key=\(constants.talkbackAPIKey)&command_string=\(command)";

        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);

        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("POST Response data string:\n \(dataString)")
                }
        }
        task.resume()
    }
    
    func deleteTalkbackCommands() {
        
        let url = URL(string: "https://api.thingspeak.com/talkbacks/38797/commands.json")
        guard let requestUrl = url else { fatalError() }

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
         
        let deleteString = "api_key=\(constants.talkbackAPIKey)";
        
        request.httpBody = deleteString.data(using: String.Encoding.utf8);

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("DELETE Response data string:\n \(dataString)")
                }
        }
        task.resume()
    }
}
