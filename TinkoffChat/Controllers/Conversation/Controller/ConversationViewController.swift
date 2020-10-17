//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 24.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    
    private let cellInditifier = String(describing: ConversationViewCell.self)
    
    var name: String = ""
    var channelId: String = ""
    var messageArray: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = name
        setTheme()
        loadData()

        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UINib(nibName: String(describing: ConversationViewCell.self), bundle: nil), forCellReuseIdentifier: cellInditifier)
    }
    
    private func loadData() {
        let dataManager = FirebaseDataManager()
        dataManager.getMessages(channelId: channelId) { [weak self] messages in
            self?.messageArray = messages
            self?.tableView?.reloadData()
        }
    }
    
    // MARK: Theme
    private func setTheme() {
        self.view.backgroundColor = Theme.current.backgroundColor
    }

}

// MARK: UITableView configure
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellInditifier) as? ConversationViewCell else { return UITableViewCell() }
        
        let message = messageArray[indexPath.row]
        cell.configure(with: message)
        
        return cell
    }
    
}
