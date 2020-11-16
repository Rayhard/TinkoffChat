//
//  RequestFactory.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 15.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

struct RequestsFactory {
    struct Requests {
        
        static func newImageURLConfig() -> RequestConfig<ImageURLParser> {
            return RequestConfig<ImageURLParser>(request: ImageURLRequest(), parser: ImageURLParser())
        }
        
        static func newImageConfig(imageUrl: String) -> RequestConfig<ImageParser> {
            let request = ImageRequest(url: imageUrl)
            return RequestConfig<ImageParser>(request: request, parser: ImageParser())
        }
    }
}
