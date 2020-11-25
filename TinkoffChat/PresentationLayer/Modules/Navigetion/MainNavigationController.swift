//
//  MainNavigationController.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 25.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationGesture = UILongPressGestureRecognizer(target: self, action: #selector(startAnimation(tapgesture:)))
        view.addGestureRecognizer(animationGesture)
    }
    
    @objc func startAnimation(tapgesture: UILongPressGestureRecognizer) {
        let emitterManager = EmitterLayerAnimator(gesture: tapgesture)
        emitterManager.startAnimation()
    }
}
