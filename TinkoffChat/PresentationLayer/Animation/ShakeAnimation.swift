//
//  ShakeAnimation.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 26.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ShakeAnimation {
    static func startShakeAnimation(layer: CALayer) {
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let move = CAKeyframeAnimation(keyPath: "position")
        move.values = [
            layer.position,
            CGPoint(x: layer.position.x + 5, y: layer.position.y),
            CGPoint(x: layer.position.x, y: layer.position.y + 5),
            CGPoint(x: layer.position.x - 5, y: layer.position.y),
            CGPoint(x: layer.position.x, y: layer.position.y - 5)
        ]
        move.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = CGFloat.pi / 10
        rotation.toValue = -CGFloat.pi / 10
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.3
        animationGroup.autoreverses = true
        animationGroup.repeatCount = .infinity
        animationGroup.fillMode = .both
        animationGroup.animations = [move, rotation]
        
        layer.add(animationGroup, forKey: nil)
    }
    
    static func stopShakeAnimation(layer: CALayer) {
        layer.removeAllAnimations()
        
        let move = CABasicAnimation(keyPath: "position")
        move.fromValue = layer.presentation()?.position
        move.toValue = layer.position
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = layer.presentation()?.value(forKeyPath: "transform.rotation") as? CGFloat
        rotation.toValue = 0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.3
        animationGroup.fillMode = .both
        animationGroup.animations = [move, rotation]
        
        layer.add(animationGroup, forKey: nil)
        
        CATransaction.setCompletionBlock {
            layer.removeAllAnimations()
        }
    }
}
