//
//  ImageParser.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 15.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ImageParser: IParser {
    typealias Model = UIImage
    
    func parse(data: Data) -> Model? {
        guard let image = UIImage(data: data) else { return nil }
        return image
    }
}
