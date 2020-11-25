//
//  ImagePickerViewController.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 14.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController {
    private let model: ImagePickerModel
    
    init(model: ImagePickerModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var headerView: UIView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBAction func closeButtonAction(_ sender: Any) {
        closeView()
    }
    
    private let cellInditifier = String(describing: ImagePickerCell.self)
    private var cellSize: CGFloat?
    var delegate: ImagePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setTheme()
        loadData()
        
        cellSize = (UIScreen.main.bounds.width - 22) / 3.0
        
        let animationGesture = UILongPressGestureRecognizer(target: self, action: #selector(startAnimation(tapgesture:)))
        view.addGestureRecognizer(animationGesture)
    }
    
    @objc func startAnimation(tapgesture: UILongPressGestureRecognizer) {
        let emitterManager = EmitterLayerAnimator(view: view, gesture: tapgesture)
        emitterManager.startAnimation()
    }
    
    private func setTheme() {
        self.view.backgroundColor = Theme.current.backgroundColor
        collectionView?.backgroundColor = Theme.current.backgroundColor
        headerView?.backgroundColor = Theme.current.inputMessageBubbleColor
    }
    
    private func loadData() {
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            self.model.fetchImagesURL()
        }
    }
    
    private func setCollectionView() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(UINib(nibName: "ImagePickerCell", bundle: nil), forCellWithReuseIdentifier: "ImagePickerCell")
    }
    
    private func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ImagePickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePickerCell", for: indexPath) as? ImagePickerCell else { return UICollectionViewCell() }
        
        cell.configure(image: UIImage(named: "placeholder"))
        cell.cellTag = indexPath.row
        
        guard cell.cellTag == indexPath.row else { return UICollectionViewCell() }
        DispatchQueue.global(qos: .userInteractive).async {
            let imageURL = self.model.data[indexPath.row].previewURL
            self.model.fetchImage(imageUrl: imageURL) { image in
                DispatchQueue.main.async {
                    cell.configure(image: image)
                    cell.layoutIfNeeded()
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.global(qos: .userInteractive).async {
            let imageURL = self.model.data[indexPath.row].webformatURL
            self.model.fetchImage(imageUrl: imageURL) { image in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.delegate?.setImage(image: image)
                    self.closeView()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == model.data.count - 7 {
            model.fetchImagesURL()
        }
    }
}

extension ImagePickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let size = cellSize else { return CGSize(width: 50, height: 50) }
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension ImagePickerViewController: ImagePickerModelDelegate {
    func loadComplited() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            self.activityIndicator?.stopAnimating()
        }
    }
    
}
