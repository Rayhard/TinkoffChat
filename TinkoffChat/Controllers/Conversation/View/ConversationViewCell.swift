//
//  ConversationViewCell.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 28.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ConversationViewCell: UITableViewCell, ConfigurableView {
    typealias ConfigurationModel = MessageCellModel
    
    @IBOutlet weak var messageBubbleView: UIView?
    @IBOutlet weak var textMessageLabel: UILabel?
    @IBOutlet var leadingConstraint: NSLayoutConstraint?
    @IBOutlet var trailingConstraint: NSLayoutConstraint?
    
    // MARK: Configure
    func configure(with model: ConfigurationModel) {
        messageBubbleView?.layer.cornerRadius = 10
        
        textMessageLabel?.text = model.text
        
        if model.isOutput {
            messageBubbleView?.backgroundColor = Theme.current.outputMessageBubbleColor
            textMessageLabel?.textColor = Theme.current.outputText
            trailingConstraint?.isActive = true
            leadingConstraint?.isActive = false
        } else {
            messageBubbleView?.backgroundColor = Theme.current.inputMessageBubbleColor
            textMessageLabel?.textColor = Theme.current.inputText
            trailingConstraint?.isActive = false
            leadingConstraint?.isActive = true
        }
    }
}
