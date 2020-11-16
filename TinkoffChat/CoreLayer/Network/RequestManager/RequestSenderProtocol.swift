//
//  RequestSenderProtocol.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 15.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

enum Result<Model> {
    case success(Model)
    case error(String)
}

//enum ApiError: Error {
//    case stringCantBeParsed
//}

protocol IRequestSender {
    func send<Parser>(pageNumber: Int?,
                      requestConfig: RequestConfig<Parser>,
                      completionHandler: @escaping(Result<Parser.Model>) -> Void)
}

//protocol IRequestSender {
//    func send<Parser>(requestConfig: RequestConfig<Parser>,
//                      completionHandler: @escaping(Result<Parser.Model, ApiError>) -> Void)
//}
