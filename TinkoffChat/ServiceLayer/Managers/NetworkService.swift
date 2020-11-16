//
//  NetworkService.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 15.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

protocol INetworkService {
    func getImageUrls(completionHandler: @escaping ([Images]?, String?) -> Void)
    func getImage(imageUrl: String, completionHandler: @escaping (UIImage?, String?) -> Void)
}

class NetworkService: INetworkService {
    private let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func getImageUrls(completionHandler: @escaping ([Images]?, String?) -> Void) {
        let requestConfig = RequestsFactory.Requests.newImageURLConfig()
        
        loadImageURL(requestConfig: requestConfig, completionHandler: completionHandler)
    }
    
    func getImage(imageUrl: String, completionHandler: @escaping (UIImage?, String?) -> Void) {
        let requestConfig = RequestsFactory.Requests.newImageConfig(imageUrl: imageUrl)
        
        loadImage(requestConfig: requestConfig, completionHandler: completionHandler)
    }
    
    private func loadImageURL(requestConfig: RequestConfig<ImageURLParser>,
                              completionHandler: @escaping ([Images]?, String?) -> Void) {
        requestSender.send(requestConfig: requestConfig) { (result: Result<[Images]>) in
            
            switch result {
            case .success(let apps):
                completionHandler(apps, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    private func loadImage(requestConfig: RequestConfig<ImageParser>,
                           completionHandler: @escaping (UIImage?, String?) -> Void) {
        requestSender.send(requestConfig: requestConfig) { (result: Result<UIImage>) in
            
            switch result {
            case .success(let apps):
                completionHandler(apps, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
}
