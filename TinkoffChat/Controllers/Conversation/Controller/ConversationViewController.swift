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
    @IBOutlet weak var messageTextView: UITextView?
    @IBOutlet weak var inputViewHight: NSLayoutConstraint?
    
    @IBOutlet weak var sendMessageButton: UIButton?
    @IBAction func sendMessageAction(_ sender: Any) {
        guard let message = messageTextView?.text,
              let id = channel?.identifier else { return }
        dataManager?.sendMessage(channelId: id, message: message)
        
        messageTextView?.text = ""
    }
    
    private let cellInditifier = String(describing: ConversationViewCell.self)

    var channel: Channel?
    var messageArray: [Message] = []
    var dataManager: FirebaseDataManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = channel?.name
        setTheme()
        loadData()
        
        messageTextView?.delegate = self
        messageTextView?.layer.cornerRadius = (messageTextView?.frame.height ?? 0) / 4

        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView?.register(UINib(nibName: String(describing: ConversationViewCell.self), bundle: nil), forCellReuseIdentifier: cellInditifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObserver()
        addKeyboardGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
    
    private func loadData() {
        guard let id = channel?.identifier else { return }
        dataManager?.getMessages(channelId: id) { [weak self] messages in
            let sortedArray = messages.sorted(by: {$0.created < $1.created})
            self?.messageArray = sortedArray.reversed()
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
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.configure(with: message)
        
        return cell
    }
    
}

// MARK: UITextViewDelegate
extension ConversationViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height > 50,
           textView.contentSize.height < 200 {
            inputViewHight?.constant = textView.contentSize.height + 16
        }
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.sendMessageButton?.isEnabled = false
        } else {
            self.sendMessageButton?.isEnabled = true
        }
    }
}

// MARK: Keyboard settings
extension ConversationViewController {
    private func addKeyboardGesture() {
        let keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        keyboardHideGesture.cancelsTouchesInView = false
        self.view?.addGestureRecognizer(keyboardHideGesture)
    }

    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        let info = notification.userInfo as NSDictionary?
        let size = (info?.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)?.cgRectValue.size

        self.view.frame.origin.y = -(size?.height ?? 0)
    }

    @objc private func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }

    @objc private func hideKeyboard() {
        self.messageTextView?.endEditing(true)
    }
}
