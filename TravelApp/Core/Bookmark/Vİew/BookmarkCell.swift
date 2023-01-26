//
//  BookmarkCell.swift
//  TravelApp
//
//  Created by İlker Kaya on 19.01.2023.
//

import UIKit

class BookmarkCell: UITableViewCell {
    
    @IBOutlet weak var backImge: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
