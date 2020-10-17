//
//  ConversationsListCell.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 24.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ConversationsListCell: UITableViewCell, ConfigurableView {
    typealias ConfigurationModel = Channel
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var textMessageLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var photoView: UIView?
    @IBOutlet weak var nameSymbolLabel: UILabel?
    @IBOutlet weak var unreadMessageMark: UIView?
    
    // MARK: Configure
    func configure(with model: ConfigurationModel) {
        self.selectionStyle = .none
        photoView?.layer.cornerRadius = (photoView?.frame.width ?? 1) / 2
        
        setTheme()
        
        nameLabel?.text = model.name
        
        nameSymbolLabel?.text = setSymbolFromName(model.name)
        
        if model.lastMessage == ""{
            settingNilMessage()
        } else {
            textMessageLabel?.font = .none
            textMessageLabel?.textColor = Theme.current.listText
            textMessageLabel?.text = model.lastMessage
            
            dateLabel?.text = formDate(model.lastActivity ?? Date())
        }
    }
    
    // MARK: Theme
    private func setTheme() {
        nameLabel?.textColor = Theme.current.textColor
        dateLabel?.textColor = Theme.current.listText
    }
    
    // MARK: Setting cell
    private func settingNilMessage() {
        textMessageLabel?.text = "No messages yet"
        textMessageLabel?.textColor = Theme.current.listText
        guard let customFont = UIFont(name: "BlackHole-Italic", size: UIFont.labelFontSize) else {
            AlertManager.showStaticAlert(withMessage: "Failed to load the \"BlackHole_Italic\" font.")
            return
        }
        textMessageLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
        textMessageLabel?.adjustsFontForContentSizeCategory = true
        
        unreadMessageMark?.isHidden = true
        
        dateLabel?.text = ""
    }
    
    private func setSymbolFromName(_ name: String) -> String {
        return String(name.prefix(1))
    }
    
    private func formDate(_ date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        if calendar.isDateInToday(date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let localDate = dateFormatter.string(from: date)
            return localDate
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM"
            let localDate = dateFormatter.string(from: date)
            return localDate
        }
    }
}
