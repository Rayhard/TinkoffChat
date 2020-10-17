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
    
    static func showStaticAlert(withMessage message: String) {
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                topController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    static func showActionAlert(withMessage message: String, closure: @escaping (ProfileInfo) -> Void) {
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            let repeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
                closure(ProfileInfo())
            }
            alertController.addAction(okAction)
            alertController.addAction(repeatAction)
            
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                topController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    static func showTextFieldAlert(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let chancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
            let createAction = UIAlertAction(title: "Создать", style: .default) { _ in
//                closure()
            }
            
            alertController.addTextField { (textField: UITextField?) in
                textField?.placeholder = "Введите название канала"
            }
            alertController.addAction(chancelAction)
            alertController.addAction(createAction)
            
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                topController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
