//
//  CharacterCollectionViewCell.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

enum CharacterCollectionViewCellType {
    case selected
    case unselected
    
    var textColor: UIColor {
        switch self {
        case .selected:
            return UIColor.white
        default:
            return UIColor(named: "dogProfileButtonTextColor") ?? UIColor.gray
        }
    }
    
    var backgroundColor: CGColor {
        switch self {
        case .selected:
            return (UIColor(named: "dogProfileDarkerOrange") ?? UIColor.orange).cgColor
        default:
            return (UIColor(named: "dogProfileLineColor") ?? UIColor.gray).cgColor
        }
    }
}

class CharacterCollectionViewCell: UICollectionViewCell {

    override var isSelected: Bool {
        didSet {
            if isSelected {
                configure(with: .selected)
            } else {
                configure(with: .unselected)
            }
        }
    }
    
    @IBOutlet weak var characteristicLabel: UILabel!
    
    @IBOutlet weak var cellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    private func configure() {
        contentView.layer.cornerRadius = 16
        cellBackgroundView.layer.cornerRadius = 16
        configure(with: .unselected)
    }
    
    private func configure(with type: CharacterCollectionViewCellType) {
        cellBackgroundView.layer.backgroundColor = type.backgroundColor
        characteristicLabel.textColor = type.textColor
    }
    
}
