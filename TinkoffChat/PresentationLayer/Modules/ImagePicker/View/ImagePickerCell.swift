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
    
    var cellTag: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = UIImage(named: "placeholder")
    }

    func configure(image: UIImage?) {
        imageView?.image = image
    }
}
