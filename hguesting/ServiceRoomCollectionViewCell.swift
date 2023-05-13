//
//  ServiceRoomCollectionViewCell.swift
//  hguesting
//
//  Created by Mac Mini 9 on 15/4/2023.
//

import UIKit

class ServiceRoomCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var imageLabel: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    
    
    
    
    
    
    var addToCartButtonAction: (() -> Void)?

        override func awakeFromNib() {
            super.awakeFromNib()
            
            addToCartButton.layer.cornerRadius = 4.0
            addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        }

        @objc func addToCartButtonTapped() {
            addToCartButtonAction?()
        }
    
    
}
