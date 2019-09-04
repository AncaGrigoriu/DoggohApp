//
//  MaximizedDogPhotoCollectionViewCell.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 22/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

protocol MaximizedDogPhotoCollectionViewCellDelegate: class {
    func minimize()
}

class MaximizedDogPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var minimizeImageView: UIImageView!
    @IBOutlet weak var breedImageView: UIImageView!
    
    weak var delegate: MaximizedDogPhotoCollectionViewCellDelegate?
    
    var viewmodel: MaximizedDogPhotoViewModel! {
        didSet {
            breedImageView.image = UIImage(data: viewmodel.imageData)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    private func configure() {
        breedImageView.layer.cornerRadius = 22
        minimizeImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(minimize))
        minimizeImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func minimize() {
        delegate?.minimize()
    }
}
