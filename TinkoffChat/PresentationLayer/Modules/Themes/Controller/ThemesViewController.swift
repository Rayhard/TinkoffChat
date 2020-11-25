//
//  ThemesViewController.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 02.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    @IBOutlet weak var classicButton: UIButton?
    @IBOutlet weak var dayButton: UIButton?
    @IBOutlet weak var nightButton: UIButton?
    
    @IBOutlet var bubbleViews: [UIView]?
    
    @IBOutlet weak var classicMessageView: UIView?
    @IBOutlet weak var dayMessageView: UIView?
    @IBOutlet weak var nightMessageView: UIView?
    
    weak var delegate: ThemesPickerDelegate?
    var setTheme: ((ThemeModel) -> Void)?
    var model: IThemesControllerModel
    
    init(model: IThemesControllerModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func setThemeAction(_ sender: UIButton) {
        switch sender {
        case classicButton:
            setClassicTheme()
            
        case dayButton:
            setDayTheme()
            
        case nightButton:
            setNightTheme()
            
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        addGestures()
        configureTheme()
    }
    
    private func addGestures() {
        let classicGesture = UITapGestureRecognizer(target: self, action: #selector(setClassicTheme))
        let dayGesture = UITapGestureRecognizer(target: self, action: #selector(setDayTheme))
        let nightGesture = UITapGestureRecognizer(target: self, action: #selector(setNightTheme))
        classicMessageView?.addGestureRecognizer(classicGesture)
        dayMessageView?.addGestureRecognizer(dayGesture)
        nightMessageView?.addGestureRecognizer(nightGesture)
    }
    
    private func setViews() {
        self.title = "Settings"
        navigationItem.largeTitleDisplayMode = .never
        
        guard let viewArray = bubbleViews else { return }
        for view in viewArray {
            view.layer.cornerRadius = view.frame.height / 6
        }
        
        classicMessageView?.layer.cornerRadius = (classicMessageView?.frame.height ?? 1) / 6
        dayMessageView?.layer.cornerRadius = (dayMessageView?.frame.height ?? 1) / 6
        nightMessageView?.layer.cornerRadius = (nightMessageView?.frame.height ?? 1) / 6
    }
    
    @objc private func setClassicTheme() {
        //            delegate?.setTheme(ClassicTheme())
        self.setTheme?(ClassicTheme())
        saveTheme(.classic)
        
        model.saveTheme(name: "classic")
        
        setupClassicView(border: 3, color: .systemBlue)
        setupDayView(border: 1, color: .gray)
        setupNightView(border: 1, color: .gray)
    }
    
    @objc private func setDayTheme() {
        //            delegate?.setTheme(DayTheme())
        self.setTheme?(DayTheme())
        saveTheme(.day)
        
        model.saveTheme(name: "day")
        
        setupDayView(border: 3, color: .systemBlue)
        setupClassicView(border: 1, color: .gray)
        setupNightView(border: 1, color: .gray)
    }
    
    @objc private func setNightTheme() {
        //            delegate?.setTheme(NightTheme())
        self.setTheme?(NightTheme())
        saveTheme(.night)
        
        model.saveTheme(name: "night")
        
        setupNightView(border: 3, color: .systemBlue)
        setupClassicView(border: 1, color: .gray)
        setupDayView(border: 1, color: .gray)
    }
    
    private func setupClassicView(border: CGFloat, color: UIColor) {
        classicMessageView?.layer.borderWidth = border
        classicMessageView?.layer.borderColor = color.cgColor
    }
    
    private func setupDayView(border: CGFloat, color: UIColor) {
        dayMessageView?.layer.borderWidth = border
        dayMessageView?.layer.borderColor = color.cgColor
    }
    
    private func setupNightView(border: CGFloat, color: UIColor) {
        nightMessageView?.layer.borderWidth = border
        nightMessageView?.layer.borderColor = color.cgColor
        
    }
    
    private func saveTheme(_ theme: CurrentTheme) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(theme.rawValue, forKey: "Theme")
        
        configureTheme()
    }
    
    private func configureTheme() {
        self.view.backgroundColor = Theme.current.backgroundColor
        
        classicButton?.tintColor = Theme.current.textColor
        dayButton?.tintColor = Theme.current.textColor
        nightButton?.tintColor = Theme.current.textColor
        
        switch Theme.current {
        case is ClassicTheme:
            setupClassicView(border: 3, color: .systemBlue)
            setupDayView(border: 1, color: .gray)
            setupNightView(border: 1, color: .gray)
        case is DayTheme:
            setupDayView(border: 3, color: .systemBlue)
            setupClassicView(border: 1, color: .gray)
            setupNightView(border: 1, color: .gray)
        case is NightTheme:
            setupNightView(border: 3, color: .systemBlue)
            setupDayView(border: 1, color: .gray)
            setupClassicView(border: 1, color: .gray)
        default:
            return
        }
    }
    
}

enum CurrentTheme: String {
    case classic
    case day
    case night
}
