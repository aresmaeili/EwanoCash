//
//  CollectionViewCell.swift
//  EwanoCash
//
//  Created by Roham on 7/7/1400 AP.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numbersButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        numbersButton.layer.cornerRadius = 0
//        numbersButton.layer.borderWidth = 0.5
        numbersButton.layer.borderColor = UIColor.lightGray.cgColor
        numbersButton.titleLabel?.textColor = .blue
    }

}
