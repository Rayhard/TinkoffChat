//
//  AnimationController.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 21.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class AnimationController: NSObject {
    
    private let animationDuration: Double
    private let animationType: AnimationType
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
    
}
extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            presentAnimation(with: transitionContext,
                             viewToAnimate: toViewController.view,
                             sourceView: fromViewController.view)
        case .dismiss: break
        //
        }
    }
    
    func presentAnimation(with context: UIViewControllerContextTransitioning, viewToAnimate: UIView, sourceView: UIView) {
        
        viewToAnimate.frame = CGRect(x: 0, y: -sourceView.frame.height,
                                     width: sourceView.frame.width, height: sourceView.frame.height)
        
        let duration = transitionDuration(using: context)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
                        viewToAnimate.frame = CGRect(x: 0, y: 0,
                                                     width: sourceView.frame.width, height: sourceView.frame.height)
                       }) { _ in
            context.completeTransition(true)
        }
    }
}
