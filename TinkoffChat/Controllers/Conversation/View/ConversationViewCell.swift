//
//  ConversationViewCell.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 28.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ConversationViewCell: UITableViewCell, ConfigurableView {
    typealias ConfigurationModel = Message
    
    @IBOutlet weak var messageBubbleView: UIView?
    @IBOutlet weak var textMessageLabel: UILabel?
    @IBOutlet var leadingConstraint: NSLayoutConstraint?
    @IBOutlet var trailingConstraint: NSLayoutConstraint?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    
    // MARK: Configure
    func configure(with model: ConfigurationModel) {
        messageBubbleView?.layer.cornerRadius = 10
        
        setTheme()
        
        textMessageLabel?.text = model.content
        nameLabel?.text = model.senderName
        timeLabel?.text = formDate(model.created)
        
        if model.senderId == UserProfile.shared.symbols {
            trailingConstraint?.isActive = true
            leadingConstraint?.isActive = false
            nameLabel?.textAlignment = .right
        } else {
            trailingConstraint?.isActive = false
            leadingConstraint?.isActive = true
            nameLabel?.textAlignment = .left
        }
    }
    
    private func setTheme() {
        messageBubbleView?.backgroundColor = Theme.current.inputMessageBubbleColor
        textMessageLabel?.textColor = Theme.current.inputText
        nameLabel?.textColor = Theme.current.inputText
        timeLabel?.textColor = Theme.current.inputText
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
