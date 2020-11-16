//
//  ImagePickerModel.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 14.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

protocol IImagePickerModel {
    var data: [Images] { get set }
    
    func fetchImagesURL()
    func fetchImage(imageUrl: String, completion: @escaping (UIImage?) -> Void)
}

protocol ImagePickerModelDelegate: class {
    func loadComplited()
}

protocol ImagePickerDelegate: class {
    func setImage(image: UIImage?)
}

class ImagePickerModel: IImagePickerModel {
    private let networkService: INetworkService
    
    init(networkService: INetworkService) {
        self.networkService = networkService
    }
    
    weak var delegate: ImagePickerModelDelegate?
    private var pageNumber = 0
    var data: [Images] = []
    
    func fetchImagesURL() {
        pageNumber += 1
        networkService.getImageUrls(pageNumber: pageNumber) { images, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let images = images else { return }
            self.data.append(contentsOf: images)
            
            self.delegate?.loadComplited()
        }
    }
    
    func fetchImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        var fetchImage = UIImage()
        networkService.getImage(imageUrl: imageUrl) { image, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let image = image else { return }
            fetchImage = image
            
            completion(fetchImage)
        }
    }
}
