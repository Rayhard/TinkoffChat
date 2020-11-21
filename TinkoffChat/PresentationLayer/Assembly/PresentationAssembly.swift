//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 06.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

private enum Storyboard: String {
    case ConversationsListViewController
}

protocol IPresentationAssembly {
    func conversationsListViewController() -> ConversationsListViewController
    func conversationViewController() -> ConversationViewController
    func profileViewController() -> ProfileViewController
    func themesViewController() -> ThemesViewController
    func imagePickerViewController() -> ImagePickerViewController
    func mainNavigationController() -> UINavigationController
}

class PresentationAssembly: IPresentationAssembly {
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func mainNavigationController() -> UINavigationController {
        appSettings()
        let nav = UINavigationController(rootViewController: conversationsListViewController())

        return nav
    }
    
    func conversationsListViewController() -> ConversationsListViewController {
        let identifier = Storyboard.ConversationsListViewController.rawValue
        let storyBoard: UIStoryboard = UIStoryboard(name: identifier, bundle: nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: identifier) as? ConversationsListViewController
        guard let conversationsListVC = resultViewController else { return ConversationsListViewController() }
        
        let model = ConversListModel(firebaseService: serviceAssembly.firebaseService,
                                     coreDataService: serviceAssembly.coreDataService,
                                     dataService: serviceAssembly.gcdService)
        
        conversationsListVC.presentationAssembly = self
        conversationsListVC.model = model
        model.delegate = conversationsListVC
        
        return conversationsListVC
    }
    
    func conversationViewController() -> ConversationViewController {
        let model = ConversModel(firebaseService: serviceAssembly.firebaseService,
                                 coreDataService: serviceAssembly.coreDataService)
        
        let conversationsVC = ConversationViewController(model: model)
        model.delegate = conversationsVC
        
        return conversationsVC
    }
    
    func profileViewController() -> ProfileViewController {
        let model = ProfileModel(dataService: serviceAssembly.gcdService,
                                 operationService: serviceAssembly.operationService)
        
        let profileVC = ProfileViewController(model: model, presentationAssembly: self)
        model.delegate = profileVC
        
        return profileVC
    }
    
    func themesViewController() -> ThemesViewController {
        let model = ThemesControllerModel(saveService: serviceAssembly.themeSaver)
        let themeVC = ThemesViewController(model: model)
        
        return themeVC
    }
    
    func imagePickerViewController() -> ImagePickerViewController {
        let model = ImagePickerModel(networkService: serviceAssembly.networkService,
                                     imageCacheService: serviceAssembly.imageCacheService)
        
        let imagePickerVC = ImagePickerViewController(model: model)
        model.delegate = imagePickerVC

        return imagePickerVC
    }
}

extension PresentationAssembly {
    private func appSettings() {
        serviceAssembly.settingsService.setTheme()
        serviceAssembly.settingsService.setProfile()
    }
}

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
