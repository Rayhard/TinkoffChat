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
    
    var messageExample: [MessageCellModel] = [
        MessageCellModel(text: "abcdsf", isOutput: true),
        MessageCellModel(text: "MessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModel", isOutput: false),
        MessageCellModel(text: "MessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModel", isOutput: true),
        MessageCellModel(text: "abcdsfabcdsf", isOutput: true),
        MessageCellModel(text: "MessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModel", isOutput: false),
        MessageCellModel(text: "MessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModelMessageCellModel", isOutput: true)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = name
        setTheme()

        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UINib(nibName: String(describing: ConversationViewCell.self), bundle: nil), forCellReuseIdentifier: cellInditifier)
    }
    
    //MARK: Theme
    private func setTheme() {
        self.view.backgroundColor = Theme.current.backgroundColor
    }

}

//MARK: UITableView configure
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageExample.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellInditifier) as? ConversationViewCell else { return UITableViewCell() }
        
        let message = messageExample[indexPath.row]
        cell.configure(with: message)
        
        return cell
    }
    
    
}
