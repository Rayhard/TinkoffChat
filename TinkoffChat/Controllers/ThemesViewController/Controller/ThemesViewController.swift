//
//  ThemesViewController.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 02.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    @IBOutlet weak var classicButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var nightButton: UIButton!
    
    @IBOutlet var bubbleViews: [UIView]!
    
    @IBOutlet weak var classicMessageView: UIView!
    @IBOutlet weak var dayMessageView: UIView!
    @IBOutlet weak var nightMessageView: UIView!
    
    
    weak var delegate: ThemesPickerDelegate?
    var setTheme: ((ThemeModel) -> Void)?
    
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
        self.title = "Settings"
        navigationItem.largeTitleDisplayMode = .never
        
        for view in bubbleViews{
            view.layer.cornerRadius = view.frame.height / 6
        }
        
        classicMessageView.layer.cornerRadius = classicMessageView.frame.height / 6
        dayMessageView.layer.cornerRadius = dayMessageView.frame.height / 6
        nightMessageView.layer.cornerRadius = nightMessageView.frame.height / 6
        
        let classicGesture = UITapGestureRecognizer(target: self, action: #selector(setClassicTheme))
        let dayGesture = UITapGestureRecognizer(target: self, action: #selector(setDayTheme))
        let nightGesture = UITapGestureRecognizer(target: self, action: #selector(setNightTheme))
        classicMessageView.addGestureRecognizer(classicGesture)
        dayMessageView.addGestureRecognizer(dayGesture)
        nightMessageView.addGestureRecognizer(nightGesture)
        
        
        configureTheme()
    }
    
    @objc private func setClassicTheme(){
        //            delegate?.setTheme(ClassicTheme())
        self.setTheme?(ClassicTheme())
        saveTheme(.classic)
        
        setupClassic(border: 3, color: .systemBlue)
        setupDay(border: 1, color: .gray)
        setupNight(border: 1, color: .gray)
    }
    
    @objc private func setDayTheme(){
        //            delegate?.setTheme(DayTheme())
        self.setTheme?(DayTheme())
        saveTheme(.day)
        
        setupDay(border: 3, color: .systemBlue)
        setupClassic(border: 1, color: .gray)
        setupNight(border: 1, color: .gray)
    }
    
    @objc private func setNightTheme(){
        //            delegate?.setTheme(NightTheme())
        self.setTheme?(NightTheme())
        saveTheme(.night)
        
        setupNight(border: 3, color: .systemBlue)
        setupClassic(border: 1, color: .gray)
        setupDay(border: 1, color: .gray)
    }
    
    private func setupClassic(border: CGFloat, color: UIColor){
        classicMessageView.layer.borderWidth = border
        classicMessageView.layer.borderColor = color.cgColor
    }
    
    private func setupDay(border: CGFloat, color: UIColor){
        dayMessageView.layer.borderWidth = border
        dayMessageView.layer.borderColor = color.cgColor
    }
    
    private func setupNight(border: CGFloat, color: UIColor){
        nightMessageView.layer.borderWidth = border
        nightMessageView.layer.borderColor = color.cgColor
        
    }
    
    private func saveTheme(_ theme: CurrentTheme){
        let userDefaults = UserDefaults.standard
        userDefaults.set(theme.rawValue, forKey: "Theme")
        
        configureTheme()
    }
    
    private func configureTheme() {
        self.view.backgroundColor = Theme.current.backgroundColor
        
        classicButton.tintColor = Theme.current.textColor
        dayButton.tintColor = Theme.current.textColor
        nightButton.tintColor = Theme.current.textColor
        
        switch Theme.current {
        case is ClassicTheme:
            setupClassic(border: 3, color: .systemBlue)
            setupDay(border: 1, color: .gray)
            setupNight(border: 1, color: .gray)
        case is DayTheme:
            setupDay(border: 3, color: .systemBlue)
            setupClassic(border: 1, color: .gray)
            setupNight(border: 1, color: .gray)
        case is NightTheme:
            setupNight(border: 3, color: .systemBlue)
            setupDay(border: 1, color: .gray)
            setupClassic(border: 1, color: .gray)
        default:
            return
        }
    }
    
}

enum CurrentTheme: String {
    case classic = "classic"
    case day = "day"
    case night = "night"
}
