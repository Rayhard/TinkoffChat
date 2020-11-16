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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(image: UIImage?) {
        imageView?.image = image
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.stopAnimating()
    }
}
