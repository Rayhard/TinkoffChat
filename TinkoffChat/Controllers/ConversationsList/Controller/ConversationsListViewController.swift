//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 24.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileSymbol: UILabel!
    
    var conversationsListExample: [ConversationCellModel] = [
        ConversationCellModel(name: "Anastasia", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Ekaterina", message: "123123123123", date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: true),
        ConversationCellModel(name: "Aleksey", message: "asdasdasd", date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Alexandr", message: "asdasdasd", date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: true),
        ConversationCellModel(name: "Человек с очень-очень длинным именем в этом чате, а может быть и на всей земле, и за всю историю", message: "И самым большим сообщением в этом разделе, где все пользователи online, а может и нет, кто знает?", date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Еще один человек с большим именем, но не таким большим как у предыдущего человека, только он уже не онлайн", message: "asdasdasd", date: Date(), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Marina", message: "asdasdasd", date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Maxim", message: "asdasdasd", date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "Nikita", message: "", date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Rudolf", message: "asdasdasd", date: Date(), isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "Timur", message: "asdasdasd", date: Date(), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Victoria", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Vladimir", message: "asdasdasd", date: Date(), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Roman", message: "Hi", date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Marat", message: "asdasdasd", date: Date(), isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "Elena", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Artur", message: "asdasdasd", date: Calendar.current.date(byAdding: .day, value: -20, to: Date()) ?? Date(), isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "Anton", message: "asdasdasd", date: Date(), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Nikolay", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Margarita", message: "asdasdasd", date: Date(), isOnline: true, hasUnreadMessages: false),
    ]
    var conversationsList: [[ConversationCellModel]] = []
    
    private func sortArray(array: [ConversationCellModel]) -> [[ConversationCellModel]]{
        var sortedArray: [[ConversationCellModel]] = [[],[]]
        for (index, item) in array.enumerated(){
            if item.isOnline{
                sortedArray[0].append(array[index])
            } else {
                sortedArray[1].append(array[index])
            }
        }
        return sortedArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conversationsList = sortArray(array: conversationsListExample)
        
        profileView.layer.cornerRadius = profileView.frame.width / 2
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        
        let openProfileGesture = UITapGestureRecognizer(target: self, action: #selector(openProfile))
        profileView.addGestureRecognizer(openProfileGesture)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ConversationsListCell", bundle: nil), forCellReuseIdentifier: "ConversationsListCell")
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    @objc
    private func openProfile(){
        let profileStoryboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController")
        self.present(profileVC, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Online"
        } else {
            return "History"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationsList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ConversationsListCell = tableView.dequeueReusableCell(withIdentifier: "ConversationsListCell") as? ConversationsListCell
        guard let cell = ConversationsListCell else { return UITableViewCell()}
        
        let item = conversationsList[indexPath.section][indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = conversationsList[indexPath.section][indexPath.row].name
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "ConversationViewController", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
        guard let destinationController = resultViewController else { return }
        destinationController.name = name
        self.navigationController?.pushViewController(destinationController, animated: true)
        
    }
    
}
