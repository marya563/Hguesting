//
//  CartTableViewCell.swift
//  hguesting
//
//  Created by Mac Mini 9 on 26/4/2023.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet var ImageView: UIImageView!
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var subtractButton: UIButton!
}
