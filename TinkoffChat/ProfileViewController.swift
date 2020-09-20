//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 11.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var nameSymbolsLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func editButtonAction(_ sender: Any) {
        showActionSheet()
    }
    
    
    var showLog: Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.showLog
    }
    
    // MARK: Lyfestyle
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        print("init - Edit button frame:\n\t \(editButton.frame)")
//    }
    // В момент инициализации VC, editButton еще не создан и имеет значение nil
    //Thread 1: Fatal error: Unexpectedly found nil while implicitly unwrapping an Optional value
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad - Edit button frame:\n\t \(editButton.frame)")
        
        circleView.layer.cornerRadius = circleView.bounds.height / 2
        saveButton.layer.cornerRadius = saveButton.bounds.height / 3
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        navigationController?.navigationBar.isHidden = true
        
        let editImageGesture = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
        circleView.addGestureRecognizer(editImageGesture)
        
        if showLog {
            print(#function)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if showLog {
            print(#function)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Размер кнопки Edit изменился из-за того что viewDidAppear вызывается после viewWillLayoutSubviews и viewDidLayoutSubviews, где происходит установка констрейнов под размер экрана
        print("viewDidAppear - Edit button frame:\n\t \(editButton.frame)")
        
        if showLog {
            print(#function)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if showLog {
            print(#function)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if showLog {
            print(#function)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if showLog {
            print(#function)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if showLog {
            print(#function)
        }
    }
    
    // MARK: Function
    @objc private func showActionSheet(){
        let optionMenu = UIAlertController(title: "Установить фото",
                                           message: "Выберете готовое фото или сделайте новое",
                                           preferredStyle: .actionSheet)
        let gallery = UIAlertAction(title: "Установить из галлереи", style: .default) { _ in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.allowsEditing = true
            vc.delegate = self
            self.present(vc, animated: true)
        }
        let photoCam = UIAlertAction(title: "Сделать фото", style: .default) { _ in
            #if targetEnvironment(simulator)
                let alertController = UIAlertController(title: nil,
                                                        message: "Устройство не имеет камеры",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ок",
                                             style: .default,
                                             handler: nil)
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            #else
                let vc = UIImagePickerController()
                vc.sourceType = .camera
                vc.allowsEditing = true
                vc.delegate = self
                self.present(vc, animated: true)
            #endif
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        optionMenu.addAction(gallery)
        optionMenu.addAction(photoCam)
        optionMenu.addAction(cancel)
        
        //Удаление предупреждения из консоли, являющимся багом Apple
        //("<NSLayoutConstraint:0x600002948d70 UIView:0x7fe06b52ea80.width == - 16   (active)>")
        optionMenu.pruneNegativeWidthConstraints()
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .camera{
            picker.dismiss(animated: true)
            
            guard let image = info[.editedImage] as? UIImage else {
                print("No image found")
                return
            }
            
            self.profileImageView.image = image
        }
        else if picker.sourceType == .photoLibrary {
            var image: UIImage
            
            if let possibleImage = info[.editedImage] as? UIImage {
                image = possibleImage
            } else if let possibleImage = info[.originalImage] as? UIImage {
                image = possibleImage
            } else {
                return
            }

            self.profileImageView.image = image

            dismiss(animated: true)
        }
    }
    
}