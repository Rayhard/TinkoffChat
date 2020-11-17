//
//  ImageCacheService.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 16.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

protocol IImageCacheService {
    func checkCache(url: String, completion: @escaping (UIImage?) -> Void)
    func saveToCache(url: String, image: UIImage)
}

class ImageCacheService: IImageCacheService {
    private var imageCache = NSCache<NSString, UIImage>()
    
    func checkCache(url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            completion(cachedImage)
        }
        completion(nil)
    }
    
    func saveToCache(url: String, image: UIImage) {
        imageCache.setObject(image, forKey: url as NSString)
    }
}
