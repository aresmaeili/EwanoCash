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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemImage.layer.cornerRadius = itemImage.frame.height / 2
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
