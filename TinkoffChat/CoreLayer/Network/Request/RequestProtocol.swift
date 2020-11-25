//
//  RequestProtocol.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 15.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

protocol IRequest {
    func urlRequest(pageNumber: Int?) -> URLRequest?
}
