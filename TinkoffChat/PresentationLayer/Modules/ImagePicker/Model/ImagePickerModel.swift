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
    private let imageCacheService: IImageCacheService
    
    init(networkService: INetworkService, imageCacheService: IImageCacheService) {
        self.networkService = networkService
        self.imageCacheService = imageCacheService
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
//        self.networkService.getImage(imageUrl: imageUrl) { loadingImage, error in
//            if let error = error {
//                print(error)
//                return
//            }
//
//            guard let imageWeb = loadingImage else { return }
////            self.imageCacheService.saveToCache(url: imageUrl, image: imageWeb)
//
//            completion(imageWeb)
//        }
        
        let finalImage = imageCacheService.checkCache(url: imageUrl)
        
        guard let image = finalImage else {
            self.networkService.getImage(imageUrl: imageUrl) { loadingImage, error in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let imageWeb = loadingImage else { return }
                self.imageCacheService.saveToCache(url: imageUrl, image: imageWeb)
                
                completion(imageWeb)
                
            }
            return
        }
        completion(finalImage)
        
//        imageCacheService.checkCache(url: imageUrl) { cachedImage in
//            if let imageCache = cachedImage {
//                completion(imageCache)
//            } else {
//                self.networkService.getImage(imageUrl: imageUrl) { loadingImage, error in
//                    if let error = error {
//                        print(error)
//                        return
//                    }
//
//                    guard let imageWeb = loadingImage else { return }
//                    self.imageCacheService.saveToCache(url: imageUrl, image: imageWeb)
//
//                    completion(imageWeb)
//                }
//            }
//        }
    }
}
