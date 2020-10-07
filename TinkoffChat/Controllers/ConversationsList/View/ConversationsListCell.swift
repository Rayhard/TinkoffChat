//
//  ConversationsListCell.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 24.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ConversationsListCell: UITableViewCell, ConfigurableView {
    typealias ConfigurationModel = ConversationCellModel
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var textMessageLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var photoView: UIView?
    @IBOutlet weak var nameSymbolLabel: UILabel?
    @IBOutlet weak var onlineMarkView: UIView!
    @IBOutlet weak var indicatorOnline: UIView!
    @IBOutlet weak var unreadMessageMark: UIView!
    
    //MARK: Configure
    func configure(with model: ConfigurationModel) {
        self.selectionStyle = .none
        photoView?.layer.cornerRadius = (photoView?.frame.width ?? 0) / 2
        
        setTheme()
        
        nameLabel?.text = model.name
        
        nameSymbolLabel?.text = setSymbolFromName(model.name)
        
        if model.message == ""{
            settingNilMessage()
        } else {
            if model.hasUnreadMessages{
                settingUnreadMessage()
            } else {
                textMessageLabel?.font = .none
                textMessageLabel?.textColor = Theme.current.listText
                unreadMessageMark.isHidden = true
            }
            
            textMessageLabel?.text = model.message
            
            dateLabel?.text = formDate(model.date)
        }
        
        if model.isOnline{
            settingOnline()
        } else {
            onlineMarkView.isHidden = true
        }
    }
    
    //MARK: Theme
    private func setTheme(){
        nameLabel?.textColor = Theme.current.textColor
        dateLabel?.textColor = Theme.current.listText
    }
    
    //MARK: Setting cell
    private func settingNilMessage(){
        textMessageLabel?.text = "No messages yet"
        textMessageLabel?.textColor = Theme.current.listText
        guard let customFont = UIFont(name: "BlackHole-Italic", size: UIFont.labelFontSize) else {
            AlertManager.showAlert(withMessage: "Failed to load the \"BlackHole_Italic\" font.Make sure the font file is included in the project and the font name is spelled correctly.")
            return
        }
        textMessageLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
        textMessageLabel?.adjustsFontForContentSizeCategory = true
        
        unreadMessageMark.isHidden = true
        
        dateLabel?.text = ""
    }
    
    private func settingUnreadMessage(){
        textMessageLabel?.font = .boldSystemFont(ofSize: 17)
        textMessageLabel?.textColor = Theme.current.listText
        unreadMessageMark.isHidden = false
        unreadMessageMark.layer.cornerRadius = unreadMessageMark.frame.width / 2
        unreadMessageMark.backgroundColor = Theme.current.outputMessageBubbleColor
    }
    
    private func settingOnline(){
        onlineMarkView.backgroundColor = Theme.current.backgroundColor
        onlineMarkView.isHidden = false
        onlineMarkView.layer.cornerRadius = onlineMarkView.frame.width / 2
        indicatorOnline.layer.cornerRadius = indicatorOnline.frame.width / 2
    }
    
    private func setSymbolFromName(_ name: String) -> String{
        return String(name.prefix(1))
    }
    
    private func formDate(_ date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        if calendar.isDateInToday(date){
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
