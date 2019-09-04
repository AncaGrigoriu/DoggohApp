//
//  BreedDetailsCollectionViewCell.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 20/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

protocol BreedDetailsCollectionViewCellDelegate: class {
    func expand()
}

class BreedDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageParentView: UIView!
    @IBOutlet weak var breedImageView: UIImageView!
    @IBOutlet weak var expandImageView: UIImageView!
    
    weak var delegate: BreedDetailsCollectionViewCellDelegate?
    
    var viewmodel: BreedDetailsTableViewCellViewModel! {
        didSet {
            breedImageView.image = UIImage(data: viewmodel.imageData)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure() {
        breedImageView.layer.cornerRadius = 22
        breedImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(maximize))
        breedImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func maximize() {
        delegate?.expand()
    }
}
