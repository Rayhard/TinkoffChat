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
    func imagePickerViewController() -> ImagePickerViewController
    func mainNavigationController() -> UINavigationController
}

class PresentationAssembly: IPresentationAssembly {
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func mainNavigationController() -> UINavigationController {
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
        let model = ImagePickerModel()
        let imagePickerVC = ImagePickerViewController(model: model)

        return imagePickerVC
    }
}
