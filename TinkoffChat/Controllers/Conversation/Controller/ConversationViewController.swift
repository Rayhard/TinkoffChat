//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 24.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var messageTextView: UITextView?
    @IBOutlet weak var inputViewHight: NSLayoutConstraint?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet weak var sendMessageButton: UIButton?
    @IBAction func sendMessageAction(_ sender: Any) {
        guard let message = messageTextView?.text,
              let id = channel?.identifier else { return }
        dataManager?.sendMessage(channelId: id, message: message)
        
        messageTextView?.text = ""
    }
    
    private let cellInditifier = String(describing: ConversationViewCell.self)

    var channel: Channel_db?
    var dataManager: FirebaseDataManager?
    
    private let dataStack: CoreDataStack = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let delegate = appDelegate else { return CoreDataStack()}
        return delegate.coreDataStack
    }()
    private lazy var fetchedResultsController: NSFetchedResultsController<Message_db>? = {
        let fetchRequest: NSFetchRequest<Message_db> = Message_db.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        guard let id = channel?.identifier else { return nil}
        let predicate = NSPredicate(format: "channel.identifier = %@", id)
        fetchRequest.predicate = predicate
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataStack.mainContext,
            sectionNameKeyPath: nil,
            cacheName: "MessageCacheForChannel\(id)")
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = channel?.name
        activityIndicator?.isHidden = false
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
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        
        guard let id = channel?.identifier else { return }
        dataManager?.getMessages(channelId: id) { [weak self] in
            self?.activityIndicator?.isHidden = true
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
        guard let sections = fetchedResultsController?.sections else { return 0 }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellInditifier) as? ConversationViewCell else { return UITableViewCell() }
        
        guard let message = fetchedResultsController?.object(at: indexPath) else { return UITableViewCell() }
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.configure(with: message)
        
        return cell
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {

        let index = indexPath ?? IndexPath()
        let newIndex = newIndexPath ?? IndexPath()
        
        switch type {
        case .insert:
            self.tableView?.insertRows(at: [newIndex], with: .automatic)
        case .move:
            self.tableView?.deleteRows(at: [index], with: .automatic)
            self.tableView?.insertRows(at: [newIndex], with: .automatic)
        case .update:
            self.tableView?.reloadRows(at: [index], with: .automatic)
        case .delete:
            self.tableView?.deleteRows(at: [index], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
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
