//
//  HomeTableViewCell.swift
//  EwanoCash
//
//  Created by Reza Kashkoul on 7/7/1400 AP.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDate: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    func fill(with item: TransactionData) {
        itemTitle.text = item.title
        itemPrice.text = item.amount.formattedWithSeparator.description + " $"
        itemDate.text = item.date.getPrettyDate()
        if item.isIncome {
            itemImage.image = UIImage(named: "chevron_down")
            itemImage.tintColor = .systemGreen
        } else {
            itemImage.image = UIImage(named: "chevron_up")
            itemImage.tintColor = .systemRed
        }
    }
    
}
