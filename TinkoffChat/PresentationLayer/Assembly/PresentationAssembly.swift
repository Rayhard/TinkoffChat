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
    case ConversationViewController
    case ProfileViewController
    case ThemesViewController
    case MainNavigationController
}

protocol IPresentationAssembly {
    func conversationsListViewController() -> ConversationsListViewController
    func conversationViewController() -> ConversationViewController
    func profileViewController() -> ProfileViewController
    func themesViewController() -> ThemesViewController
    func mainNavigationController() -> MainNavigationController
}

class PresentationAssembly: IPresentationAssembly {
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func mainNavigationController() -> MainNavigationController {
        let identifier = Storyboard.MainNavigationController.rawValue
        let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.ConversationsListViewController.rawValue, bundle: nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: identifier) as? MainNavigationController
        guard let navigationC = resultViewController else { return MainNavigationController() }
        navigationC.setViewControllers([conversationsListViewController()], animated: true)
        
        return navigationC
    }
    
    func conversationsListViewController() -> ConversationsListViewController {
        let identifier = Storyboard.ConversationsListViewController.rawValue
        let storyBoard: UIStoryboard = UIStoryboard(name: identifier, bundle: nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: identifier) as? ConversationsListViewController
        guard let conversationsListVC = resultViewController else { return ConversationsListViewController() }
        
        let firebaseModel = ConversListFirebaseModel(firebaseService: serviceAssembly.firebaseService, coreDataService: serviceAssembly.coreDataService)
        let dataFileModel = ConversListDataFileModel(dataService: serviceAssembly.gcdService)
        
        conversationsListVC.presentationAssembly = self
        conversationsListVC.modelFirebase = firebaseModel
        conversationsListVC.modelDataFile = dataFileModel
        firebaseModel.delegate = conversationsListVC
        
        return conversationsListVC
    }
    
    func conversationViewController() -> ConversationViewController {
        let identifier = Storyboard.ConversationViewController.rawValue
        let storyBoard: UIStoryboard = UIStoryboard(name: identifier, bundle: nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: identifier) as? ConversationViewController
        guard let conversationsVC = resultViewController else { return ConversationViewController() }
        
        let model = ConversFirebaseModel(firebaseService: serviceAssembly.firebaseService, coreDataService: serviceAssembly.coreDataService)
        conversationsVC.model = model
        model.delegate = conversationsVC
        
        return conversationsVC
    }
    
    func profileViewController() -> ProfileViewController {
        let identifier = Storyboard.ProfileViewController.rawValue
        let storyBoard: UIStoryboard = UIStoryboard(name: identifier, bundle: nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: identifier) as? ProfileViewController
        guard let profileVC = resultViewController else { return ProfileViewController() }
        
        let modelGCD = ProfileDataFileModel(dataService: serviceAssembly.gcdService)
        profileVC.modelGCD = modelGCD
        modelGCD.delegate = profileVC
        
        let modelOperation = ProfileDataFileModel(dataService: serviceAssembly.operationService)
        profileVC.modelOperation = modelOperation
        modelOperation.delegate = profileVC
        
        return profileVC
    }
    
    func themesViewController() -> ThemesViewController {
        let identifier = Storyboard.ThemesViewController.rawValue
        let storyBoard: UIStoryboard = UIStoryboard(name: identifier, bundle: nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: identifier) as? ThemesViewController
        guard let themeVC = resultViewController else { return ThemesViewController() }
        
        return themeVC
    }
}
