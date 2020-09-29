//
//  AlertManager.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 22.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

final class AlertManager {
    private init() {}
    
    static func showAlert(withMessage message: String) {
        DispatchQueue.main.async {
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            let viewController = appDelegate.window!.rootViewController as! UINavigationController
            
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ок", style: .default) { (alert) in
            }

            alertController.addAction(okAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
