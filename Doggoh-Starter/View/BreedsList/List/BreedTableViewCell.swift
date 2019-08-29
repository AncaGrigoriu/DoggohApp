//
//  DogSectionTableViewCell.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class BreedTableViewCell: UITableViewCell, CellConfigurable {

    @IBOutlet weak var breedImageView: UIImageView!
    
    @IBOutlet weak var breedLabel: UILabel!
    
    func config(with dog: Breed) {
        if let data = dog.photo as Data? {
            breedImageView.image = UIImage(data: data)
        } else {
            breedImageView.image = UIImage()
        }
        breedLabel.text = dog.specificBreedName
        breedImageView.layer.cornerRadius = breedImageView.bounds.height / 2
    }
}
