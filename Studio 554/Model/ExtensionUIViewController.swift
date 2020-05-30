//
//  ExtensionUIViewController.swift
//  Studio 554
//
//  Created by Alex Luke on 5/29/20.
//  Copyright © 2020 Alex Luke. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentWarningAlert(title: String, message: String = "") {
       
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
           
            // what will happen when user clicks "OK" button.
        }
    
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
