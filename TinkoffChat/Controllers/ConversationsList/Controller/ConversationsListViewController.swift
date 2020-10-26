//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 24.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var profileView: UIView?
    @IBOutlet weak var profileImage: UIImageView?
    @IBOutlet weak var profileSymbol: UILabel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    @IBAction func openThemeViewAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ThemesViewController", bundle: nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ThemesViewController") as? ThemesViewController
        guard let destinationController = resultViewController else { return }
        
//        destinationController.delegate = self
        destinationController.setTheme = { [weak self] theme in
            Theme.current = theme
            self?.configureTheme(theme)
        }
        
        self.navigationController?.pushViewController(destinationController, animated: true)
    }
    
    @IBAction func createNewChannelAction(_ sender: Any) {
        AlertManager.showTextFieldAlert(message: "Создать новый канал?") { (name) in
            self.dataManager.createNewChannel(name: name)
        }
    }
    
    private let cellInditifier = String(describing: ConversationsListCell.self)
    
    private let dataStack: CoreDataStack = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let delegate = appDelegate else { return CoreDataStack()}
        return delegate.coreDataStack
    }()
    lazy var dataManager = FirebaseDataManager(coreDataStack: dataStack)

    var channelsArray: [Channel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTheme(Theme.current)
        loadData()
        
        activityIndicator?.isHidden = false
        
        profileView?.layer.cornerRadius = (profileView?.frame.width ?? 1) / 2
        profileImage?.layer.cornerRadius = (profileImage?.frame.width ?? 1) / 2
        profileImage?.clipsToBounds = true
        
        let openProfileGesture = UITapGestureRecognizer(target: self, action: #selector(openProfile))
        profileView?.addGestureRecognizer(openProfileGesture)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UINib(nibName: String(describing: ConversationsListCell.self), bundle: nil), forCellReuseIdentifier: cellInditifier)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let dataManager = OperationDataManager()
//        let dataManager = GCDDataManager()
        let profile = dataManager.fetchData()
        profileImage?.image = profile.photo
    }
    
    @objc
    private func openProfile() {
        let profileStoryboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController")
        self.present(profileVC, animated: true)
    }
    
    private func loadData() {
        dataManager.getChannels(completion: { [weak self] channels in
            let sortedArray = channels.sorted(by: {($0.lastActivity ?? Date()) > ($1.lastActivity ?? Date())})
            self?.channelsArray = sortedArray
            self?.tableView?.reloadData()
            self?.activityIndicator?.isHidden = true
        })
    }
    
    // MARK: Theme
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

// MARK: UITableView configure
extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellInditifier) as? ConversationsListCell else { return UITableViewCell()}
        
        let item = channelsArray[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channelsArray[indexPath.row]

        let storyBoard: UIStoryboard = UIStoryboard(name: "ConversationViewController", bundle: nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
        guard let destinationController = resultViewController else { return }
        destinationController.channel = channel
        destinationController.dataManager = self.dataManager
        self.navigationController?.pushViewController(destinationController, animated: true)

    }
}

// MARK: Method theme delegat
//extension ConversationsListViewController: ThemesPickerDelegate{
//    func setTheme(_ theme: ThemeModel) {
//        Theme.current = theme
//        configureTheme(theme)
//    }
//}
