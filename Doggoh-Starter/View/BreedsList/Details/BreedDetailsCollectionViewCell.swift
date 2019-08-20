//
//  BreedDetailsCollectionViewCell.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 20/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class BreedDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var breedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure() {
        breedImageView.layer.cornerRadius = 22
    }
}
