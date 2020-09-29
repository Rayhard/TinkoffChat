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
    
    func configure(with model: ConversationCellModel) {
        self.selectionStyle = .none
        photoView?.layer.cornerRadius = (photoView?.frame.width ?? 0) / 2
        
        nameLabel?.text = model.name
        
        nameSymbolLabel?.text = setSymbolFromName(model.name)
        
        if model.message == ""{
            settingNilMessage()
        } else {
            if model.hasUnreadMessages{
                textMessageLabel?.font = .boldSystemFont(ofSize: 17)
                textMessageLabel?.textColor = .black
            } else {
                textMessageLabel?.font = .none
                textMessageLabel?.textColor = UIColor(named: "LabelLight")
            }
            
            textMessageLabel?.text = model.message
            
            dateLabel?.text = formDate(model.date)
        }
        
        if model.isOnline{
            backgroundColor = UIColor(named: "LightYellow")
        } else {
            backgroundColor = UIColor.white
        }
    }
    
    private func settingNilMessage(){
        textMessageLabel?.text = "No messages yet"
        textMessageLabel?.textColor = UIColor(named: "LabelLight")
        guard let customFont = UIFont(name: "BlackHole-Italic", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "BlackHole_Italic" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        textMessageLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
        textMessageLabel?.adjustsFontForContentSizeCategory = true
        
        dateLabel?.text = ""
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
