//
//  DogTableViewCell.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class SubBreedTableViewCell: UITableViewCell, CellConfigurable {

    @IBOutlet weak var breedImageView: UIImageView!
    
    @IBOutlet weak var breedLabel: UILabel!
    
    var viewmodel: SubBreedTableViewCellViewModel! {
        didSet {
            breedLabel.text = viewmodel.breedNameString
            if let data = viewmodel.breedImageData {
                breedImageView.image = UIImage(data: data)
            } else {
                breedImageView.image = UIImage()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        breedImageView.layer.cornerRadius = breedImageView.bounds.height / 2
    }
    
    func configImage(with data: Data) {
        breedImageView.image = UIImage(data: data)
    }
    
}
