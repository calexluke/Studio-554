//
//  NetworkingManager.swift
//  Studio 554
//
//  Created by Alex Luke on 5/28/20.
//  Copyright © 2020 Alex Luke. All rights reserved.
//

import Foundation

struct ClimateControlManager {
    
    let talkbackAPIKey = "3BLTM545BWPLGI4O"
    let temperatureURL = "https://api.thingspeak.com/channels/1067747/fields/1/last.txt?api_key=GRW3H6TCCNKMRTCP"
    
    
    func requestChannelFeed(field: Int) {
        
        // field refers to data streams in the thingspeak channel. field 1 is temperature data, firld 2 and 3 are heater and ac status
        
        let urlString = "https://api.thingspeak.com/channels/1067747/fields/\(field)/last.txt?api_key=GRW3H6TCCNKMRTCP"
    
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

    func requestTemperature(with urlString: String) {
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
                    let temperatureString = String(data: safeData, encoding: .utf8)!
                    model.updateTemperature(with: temperatureString)
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func addTalkbackCommand (_ command: String) {
        
        // Prepare URL
        let url = URL(string: "https://api.thingspeak.com/talkbacks/38797/commands.json")
        guard let requestUrl = url else { fatalError() }

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "api_key=\(talkbackAPIKey)&command_string=\(command)";

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
                    print("Response data string:\n \(dataString)")
                }
        }
        task.resume()
    }
}
