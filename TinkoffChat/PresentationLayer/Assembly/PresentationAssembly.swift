//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 06.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

protocol IPresentationAssembly {
    func conversationsListViewController() -> ConversationsListViewController
    func conversationViewController() -> ConversationViewController
    func profileViewController() -> ProfileViewController
    func themesViewController() -> ThemesViewController
}

class PresentationAssembly: IPresentationAssembly {
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func conversationsListViewController() -> ConversationsListViewController {
        return ConversationsListViewController()
    }
    
    func conversationViewController() -> ConversationViewController {
        return ConversationViewController()
    }
    
    func profileViewController() -> ProfileViewController {
        return ProfileViewController()
    }
    
    func themesViewController() -> ThemesViewController {
        return ThemesViewController()
    }
}
