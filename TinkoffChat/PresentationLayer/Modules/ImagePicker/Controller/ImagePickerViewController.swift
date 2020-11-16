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
    @IBAction func closeButtonAction(_ sender: Any) {
        closeView()
    }
    
    private let cellInditifier = String(describing: ImagePickerCell.self)
    private var cellSize: CGFloat?
    var delegate: ImagePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        DispatchQueue.global(qos: .background).async {
            self.model.fetchImagesURL()
        }
        
        cellSize = (UIScreen.main.bounds.width - 22) / 3.0
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
        
        DispatchQueue.global(qos: .background).async {
            let imageURL = self.model.data[indexPath.row].previewURL
            self.model.fetchImage(imageUrl: imageURL) { image in
                DispatchQueue.main.async {
                    cell.configure(image: image)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ImagePickerCell
        let image = cell?.imageView?.image
        delegate?.setImage(image: image)
        closeView()
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
        }
    }
    
}
