//
//  CustomLayer.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 23.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class EmitterLayerAnimator {
    
    private weak var view: UIView?
    private weak var gesture: UIGestureRecognizer?
    
    init(view: UIView, gesture: UIGestureRecognizer) {
        self.view = view
        self.gesture = gesture
    }
    
    func startAnimation() {
        let particleEmitter = CAEmitterLayer()
        
        guard let location = gesture?.location(in: view) else { return }
        
        particleEmitter.emitterPosition = location
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: 5, height: 1)
        
        let cell = makeEmitterCell()
        particleEmitter.emitterCells = [cell]
        
        switch gesture?.state {
        case .began:
            view?.layer.addSublayer(particleEmitter)
        case .changed:
            stopAnimate()
            view?.layer.addSublayer(particleEmitter)
        case .ended:
            stopAnimate()
        default:
            stopAnimate()
        }
    }
    
    private func makeEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 2
        cell.lifetime = 1.0
        cell.lifetimeRange = 0
        cell.velocity = 100
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 1
        cell.spinRange = 2
        cell.scale = 0.1
        cell.scaleRange = 0.2
        cell.scaleSpeed = -0.05
        
        cell.contents = UIImage(named: "logo")?.cgImage
        return cell
    }
    
    private func stopAnimate() {
        guard let allSublayers = view?.layer.sublayers else { return }
        for layer in allSublayers {
            guard let emitterLayer = layer as? CAEmitterLayer else { continue }
            emitterLayer.removeAllAnimations()
            emitterLayer.removeFromSuperlayer()
        }
    }
}
