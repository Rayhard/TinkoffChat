//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 11.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var circleView: UIView?
    @IBOutlet weak var nameSymbolsLabel: UILabel?
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var descriptionTextView: UITextView?
    @IBOutlet weak var saveOperationButton: UIButton?
    @IBOutlet weak var saveGCDButton: UIButton?
    @IBOutlet weak var editPhotoButton: UIButton?
    @IBOutlet weak var profileImageView: UIImageView?
    @IBOutlet weak var headerView: UIView?
    @IBOutlet weak var headerTitle: UILabel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var editProfileButton: UIButton?
    
    let presentationAssembly: IPresentationAssembly
    let model: IProfileModel
    
    init(model: IProfileModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func editPhotoButtonAction(_ sender: Any) {
        showActionSheet()
    }
    @IBAction func editProfileInfoAction(_ sender: Any) {
        guard let layer = editProfileButton?.layer else { return }
        if editedEnable {
            ShakeAnimation.stopShakeAnimation(layer: layer)
            isEdited(false)
        } else {
            ShakeAnimation.startShakeAnimation(layer: layer)
            isEdited(true)
        }
        
        editedEnable = !editedEnable
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveOperationAction(_ sender: Any) {
        activityIndicator?.isHidden = false
        setStateSaveButtons(state: false)
        model.saveOperation(profile: newProfileInfo)
    }
    @IBAction func saveGCDAction(_ sender: Any) {
        activityIndicator?.isHidden = false
        setStateSaveButtons(state: false)
        model.saveGCD(profile: newProfileInfo)
    }
    
    var newProfileInfo: ProfileInfo = ProfileInfo()
    private var editedEnable: Bool = false
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        setViews()
        loadProfileData()
        addKeyboardGesture()
        isEdited(false)
        setViewForTest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
    
    @objc func nameEditing() {
        if nameTextField?.text == UserProfile.shared.name {
            setStateSaveButtons(state: false)
        } else {
            newProfileInfo.name = nameTextField?.text
            setStateSaveButtons(state: true)
        }
    }
    
    private func setViewForTest() {
        descriptionTextView?.isAccessibilityElement = true
        nameTextField?.isAccessibilityElement = true
        editProfileButton?.isAccessibilityElement = true
        
        descriptionTextView?.accessibilityIdentifier = "DescriptionTextView"
        nameTextField?.accessibilityIdentifier = "NameTextField"
        editProfileButton?.accessibilityIdentifier = "EditProfileButton"
    }
    
    private func setViews() {
        descriptionTextView?.delegate = self
        
        circleView?.layer.cornerRadius = (circleView?.bounds.height ?? 1) / 2
        saveOperationButton?.layer.cornerRadius = (saveOperationButton?.bounds.height ?? 1) / 3
        saveGCDButton?.layer.cornerRadius = (saveGCDButton?.bounds.height ?? 1) / 3
        profileImageView?.layer.cornerRadius = (profileImageView?.bounds.height ?? 1) / 2
        profileImageView?.clipsToBounds = true
        navigationController?.navigationBar.isHidden = true
        
        nameTextField?.addTarget(self, action: #selector(nameEditing), for: .editingChanged)
    }
    
    // MARK: Theme
    private func setTheme() {
        self.view.backgroundColor = Theme.current.inputMessageBubbleColor
        scrollView?.backgroundColor = Theme.current.backgroundColor
        nameTextField?.textColor = Theme.current.textColor
        descriptionTextView?.textColor = Theme.current.textColor
        descriptionTextView?.backgroundColor = Theme.current.backgroundColor
        
        headerTitle?.textColor = Theme.current.textColor
        saveOperationButton?.backgroundColor = Theme.current.inputMessageBubbleColor
        saveGCDButton?.backgroundColor = Theme.current.inputMessageBubbleColor
        headerView?.backgroundColor = Theme.current.inputMessageBubbleColor
    }
    
    // MARK: Function
    @objc private func showActionSheet() {
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
            
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                AlertManager.showStaticAlert(withMessage: "Устройство не имеет камеры")
                return
            }
            self.checkCameraPermission()
            
        }
        let imagePicker = UIAlertAction(title: "Загрузить", style: .default) { _ in
            let vc = self.presentationAssembly.imagePickerViewController()
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        optionMenu.addAction(gallery)
        optionMenu.addAction(photoCam)
        optionMenu.addAction(imagePicker)
        optionMenu.addAction(cancel)
        
        //Удаление предупреждения из консоли, являющимся багом Apple
        //("<NSLayoutConstraint:0x600002948d70 UIView:0x7fe06b52ea80.width == - 16   (active)>")
        optionMenu.pruneNegativeWidthConstraints()
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    private func checkCameraPermission() {
        let showCameraController = {
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            self.present(vc, animated: true)
        }
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            showCameraController()
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        showCameraController()
                    } else {
                        AlertManager.showStaticAlert(withMessage: "Не предоставлен доступ к камере.\nПерейдите в настройки и предоставте доступ")
                    }
                }
            }
        }
    }
    
    private func isEdited(_ state: Bool) {
        nameTextField?.isEnabled = state
        descriptionTextView?.isEditable = state
        descriptionTextView?.isSelectable = state
        editPhotoButton?.isHidden = !state
        
        let editImageGesture = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
        if state {
            circleView?.addGestureRecognizer(editImageGesture)
        } else {
            circleView?.removeGestureRecognizer(editImageGesture)
        }
    }
    
    private func setStateSaveButtons(state: Bool) {
        saveGCDButton?.isEnabled = state
        saveOperationButton?.isEnabled = state
    }
    
    private func loadProfileData() {
        let profileInfo = model.loadGCD()
        nameTextField?.text = profileInfo.name
        nameSymbolsLabel?.text = UserProfile.shared.symbols
        descriptionTextView?.text = profileInfo.description
        profileImageView?.image = profileInfo.photo
    }
    
}

// MARK: Picker delegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if picker.sourceType == .camera {
            picker.dismiss(animated: true)
            
            guard let image = info[.editedImage] as? UIImage else {
                AlertManager.showStaticAlert(withMessage: "Не удалось получить изображение")
                return
            }
            
            self.profileImageView?.image = image
            newProfileInfo.photo = image
        } else if picker.sourceType == .photoLibrary {
            var image: UIImage
            
            if let possibleImage = info[.editedImage] as? UIImage {
                image = possibleImage
            } else if let possibleImage = info[.originalImage] as? UIImage {
                image = possibleImage
            } else {
                AlertManager.showStaticAlert(withMessage: "Не удалось получить изображение")
                return
            }
            
            self.profileImageView?.image = image
            newProfileInfo.photo = image
            
            dismiss(animated: true)
        }
        
        setStateSaveButtons(state: true)
    }
    
}

// MARK: UITextViewDelegate
extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if descriptionTextView?.text == UserProfile.shared.description {
            setStateSaveButtons(state: false)
        } else {
            newProfileInfo.description = descriptionTextView?.text
            
            setStateSaveButtons(state: true)
        }
    }
}

// MARK: Keyboard settings
extension ProfileViewController {
    private func addKeyboardGesture() {
        let keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        keyboardHideGesture.cancelsTouchesInView = false
        self.scrollView?.addGestureRecognizer(keyboardHideGesture)
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
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: size?.height ?? 0, right: 0)
        self.scrollView?.contentInset = contentInsets
        self.scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView?.contentInset = .zero
    }
    
    @objc private func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
}

// MARK: IDataFileServiceDelegate
extension ProfileViewController: IDataFileServiceDelegate {
    func saveComplited() {
        DispatchQueue.main.async {
            self.isEdited(false)
            self.activityIndicator?.isHidden = true
            
            AlertManager.showStaticAlert(withMessage: "Данные сохранены")
        }
    }
    
    func loadComplited() {
        DispatchQueue.main.async {
            self.isEdited(false)
            self.activityIndicator?.isHidden = true
        }
    }
}

extension ProfileViewController: ImagePickerDelegate {
    func setImage(image: UIImage?) {
        profileImageView?.image = image
        newProfileInfo.photo = image
        if image == UserProfile.shared.photo {
            setStateSaveButtons(state: false)
        } else {
            setStateSaveButtons(state: true)
        }
    }
}
