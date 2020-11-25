//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 15.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

class RequestSender: IRequestSender {
    private func getSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        return session
    }
    
    func send<Parser>(pageNumber: Int?,
                      requestConfig config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model, ApiError>) -> Void) where Parser: IParser {
        
        let session = getSession()
        guard let urlRequest = config.request.urlRequest(pageNumber: pageNumber) else {
            completionHandler(.failure(.stringCantBeParsed))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(.failure(.taskError))
                return
            }
            
            guard let data = data,
                  let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                completionHandler(.failure(.dataCantBeParsed))
                return
            }

            completionHandler(Result.success(parsedModel))
        }
        task.resume()
    }
}
