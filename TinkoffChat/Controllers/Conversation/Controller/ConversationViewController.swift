//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 24.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
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

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ConversationViewCell", bundle: nil), forCellReuseIdentifier: "ConversationViewCell")
    }

}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageExample.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCell = tableView.dequeueReusableCell(withIdentifier: "ConversationViewCell") as? ConversationViewCell
        guard let cell = messageCell else { return UITableViewCell() }
        
        let message = messageExample[indexPath.row]
        cell.configure(with: message)
        
        return cell
    }
    
    
}
