//
//  HomeCell.swift
//  TravelApp
//
//  Created by İlker Kaya on 20.01.2023.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var bookmarkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        bookmarkImage.isUserInteractionEnabled = true
        bookmarkImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //let tappedImage = tapGestureRecognizer.view as! UIImageView // 1
        control()
    }
    
    func control() {
        if bookmarkImage.image == UIImage(systemName: "bookmark"){
            bookmarkImage.image = UIImage(systemName: "bookmark.fill")
        } else if bookmarkImage.image == UIImage(systemName: "bookmark.fill") {
            bookmarkImage.image = UIImage(systemName: "bookmark")
        }
    }
}
