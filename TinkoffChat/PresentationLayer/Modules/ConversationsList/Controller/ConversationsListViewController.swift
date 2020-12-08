//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 24.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var profileView: UIView?
    @IBOutlet weak var profileImage: UIImageView?
    @IBOutlet weak var profileSymbol: UILabel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    var presentationAssembly: IPresentationAssembly?
    var model: IConversListModel?
    
    @IBAction func openThemeViewAction(_ sender: Any) {
        guard let destinationController = presentationAssembly?.themesViewController() else { return }
//        destinationController.delegate = self
        destinationController.setTheme = { [weak self] theme in
            Theme.current = theme
            self?.configureTheme(theme)
        }
        self.navigationController?.pushViewController(destinationController, animated: true)
    }
    
    @IBAction func createNewChannelAction(_ sender: Any) {
        AlertManager.showTextFieldAlert(message: "Создать новый канал?") { (name) in
            self.model?.createNewChannel(name: name)
        }
    }
    
    private let cellInditifier = String(describing: ConversationsListCell.self)
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Channel_db> = {
        let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 18
        
        guard let context = model?.context() else { return NSFetchedResultsController() }
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: "ChannelsCache")
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTheme(Theme.current)
        loadData()
        setTableView()
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let profile = model?.loadUserInfo()
        profileImage?.image = profile?.photo
    }
    
    private func setTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UINib(nibName: String(describing: ConversationsListCell.self), bundle: nil), forCellReuseIdentifier: cellInditifier)
    }
    
    private func setViews() {
        activityIndicator?.isHidden = false
        
        profileView?.isAccessibilityElement = true
        profileView?.accessibilityIdentifier = "OpenProfileButton"
        
        profileView?.layer.cornerRadius = (profileView?.frame.width ?? 1) / 2
        profileImage?.layer.cornerRadius = (profileImage?.frame.width ?? 1) / 2
        profileImage?.clipsToBounds = true
        
        let openProfileGesture = UITapGestureRecognizer(target: self, action: #selector(openProfile))
        profileView?.addGestureRecognizer(openProfileGesture)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    @objc
    private func openProfile() {
        guard let profileVC = presentationAssembly?.profileViewController() else { return }
        profileVC.modalPresentationStyle = .custom
        profileVC.transitioningDelegate = self
        present(profileVC, animated: true, completion: nil)
    }
    
    private func loadData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
        model?.fetchChannels()
    }
    
    // MARK: - Theme
    private func configureTheme(_ theme: ThemeModel) {
        UITableView.appearance().backgroundColor = theme.backgroundColor
        UITableViewCell.appearance().backgroundColor = theme.backgroundColor

        tableView?.reloadData()

        self.navigationController?.navigationBar.barStyle = theme.navigationBarStyle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
        self.view.backgroundColor = theme.backgroundColor
    }
}

// MARK: - UITableView configure
extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellInditifier) as? ConversationsListCell else { return UITableViewCell()}
        
        let channel = fetchedResultsController.object(at: indexPath)
        cell.configure(with: channel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channel = fetchedResultsController.object(at: indexPath)
            model?.removeChannel(channel: channel)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = fetchedResultsController.object(at: indexPath)
        guard let destinationController = presentationAssembly?.conversationViewController() else { return }
        destinationController.channel = channel
        self.navigationController?.pushViewController(destinationController, animated: true)

    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
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

// MARK: - IConversationsListModelDelegate
extension ConversationsListViewController: IConversListModelDelegate {
    func loadComplited() {
        activityIndicator?.isHidden = true
    }
}

extension ConversationsListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 1, animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 0.5, animationType: .dismiss)
    }
}

// MARK: - Method theme delegat
//extension ConversationsListViewController: ThemesPickerDelegate{
//    func setTheme(_ theme: ThemeModel) {
//        Theme.current = theme
//        configureTheme(theme)
//    }
//}
