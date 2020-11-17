//
//  ImagePickerCell.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 14.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class ImagePickerCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        imageView?.image = UIImage(named: "placeholder")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        dataTask?.cancel()
        imageView?.image = UIImage(named: "placeholder")
    }

    func configure(image: UIImage?) {
        imageView?.image = image
    }
}
