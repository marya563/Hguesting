//
//  MyCollectionViewCell.swift
//  hguesting
//
//  Created by Mac Mini 9 on 14/4/2023.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Configure the cell here
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
    }

}

