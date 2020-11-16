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
    
    func send<Parser>(requestConfig config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser: IParser {
        
        let session = getSession()
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.error("url string can't be parsed to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completionHandler(Result.error(error.localizedDescription))
                return
            }
            
            guard let data = data,
                  let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                completionHandler(Result.error("received data can't be parsed"))
                return
            }

            completionHandler(Result.success(parsedModel))
        }
        task.resume()
    }
}
