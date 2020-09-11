//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 11.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var showLog: Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.showLog
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if showLog {
            print(#function)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if showLog {
            print(#function)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showLog {
            print(#function)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if showLog {
            print(#function)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if showLog {
            print(#function)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if showLog {
            print(#function)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if showLog {
            print(#function)
        }
    }
    
    
}

