//
//  Requests.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 15.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

class ImageURLRequest: IRequest {
    func urlRequest(pageNumber: Int?) -> URLRequest? {
        guard let pageNumber = pageNumber,
              let url = urlConstructor(pageNumber: pageNumber) else { return nil }
        return URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad)
    }
    
    private func urlConstructor(pageNumber: Int) -> URL? {
        var urlConstructor = URLComponents()
        
        urlConstructor.scheme = "https"
        urlConstructor.host = "pixabay.com"
        urlConstructor.path = "/api"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "key", value: "19115888-415eac269de104437b7592c97"),
            URLQueryItem(name: "q", value: "yellow+flowers"),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "per_page", value: "30")
        ]
        
        return urlConstructor.url
    }
}

class ImageRequest: IRequest {
    var url: String
    
    func urlRequest(pageNumber: Int?) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        return URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad)
    }
    
    init(url: String) {
        self.url = url
    }
}
