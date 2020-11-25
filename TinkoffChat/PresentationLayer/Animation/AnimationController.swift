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
        case .dismiss:
            dismissAnimation(with: transitionContext,
                             viewToAnimate: fromViewController.view,
                             sourceView: toViewController.view)
        }
    }
    
    func presentAnimation(with context: UIViewControllerContextTransitioning, viewToAnimate: UIView, sourceView: UIView) {
        let duration = transitionDuration(using: context)
        let size = sourceView.frame
        
        viewToAnimate.frame = CGRect(x: 0, y: -size.height,
                                     width: size.width, height: size.height)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
                        viewToAnimate.frame = CGRect(x: 0, y: 0,
                                                     width: size.width, height: size.height)
                        
                       }, completion: { _ in
                        context.completeTransition(true)
                       })
    }
    
    func dismissAnimation(with context: UIViewControllerContextTransitioning, viewToAnimate: UIView, sourceView: UIView) {
        let duration = transitionDuration(using: context)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: [],
                       animations: {
                        viewToAnimate.frame = CGRect(x: 0, y: -sourceView.frame.height,
                                                     width: sourceView.frame.width, height: sourceView.frame.height)
                       }, completion: { _ in
                        viewToAnimate.removeFromSuperview()
                        context.completeTransition(true)
                       })
    }
}
