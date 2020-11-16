//
//  Requests.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 15.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

class ImageURLRequest: IRequest {
    var urlRequest: URLRequest? {
        guard let url = urlConstructor() else { return nil }
        return URLRequest(url: url)
    }
    
    private func urlConstructor() -> URL? {
        var urlConstructor = URLComponents()
        
        urlConstructor.scheme = "https"
        urlConstructor.host = "pixabay.com"
        urlConstructor.path = "/api"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "key", value: "19115888-415eac269de104437b7592c97"),
            URLQueryItem(name: "q", value: "yellow+flowers"),
            URLQueryItem(name: "image_type", value: "photo")
        ]
        
        return urlConstructor.url
    }
}

class ImageRequest: IRequest {
    var url: String
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: url) else { return nil }
        return URLRequest(url: url)
    }
    
    init(url: String) {
        self.url = url
    }
}
