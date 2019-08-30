//
//  DogCollectionViewCell.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class DogCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dogImageView: UIImageView!
    
    @IBOutlet weak var dogNameLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 5 : 0
        }
    }
    
    var dog: Dog! {
        didSet {
            guard let image = dog.image else { return }
            dogImageView.image = UIImage(data: image as Data)
            dogNameLabel.text = dog.name
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 22
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.orange.cgColor
    }
    
}
