//
//  DogDescriptionButton.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 06/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

enum DogDescriptionButtonType {
    case selected
    case unselected
    
    var height: CGFloat {
        return 32.0
    }
    
    var cornerRadius: CGFloat {
        return 16
    }
    
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

class DogDescriptionButton: UIButton {
    
    var buttonState: DogDescriptionButtonType!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        buttonState = .unselected
        configure(withType: .unselected)
    }

    func configure(withType type: DogDescriptionButtonType) {
        buttonState = type
        setTitleColor(type.textColor, for: .normal)
        
        heightAnchor.constraint(greaterThanOrEqualToConstant: type.height).isActive = true
        layer.masksToBounds = true
        layer.cornerRadius = type.cornerRadius
        layer.backgroundColor = type.backgroundColor
        
        titleLabel?.font = UIFont(name: "Montserrat", size: 14)!
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = NSTextAlignment.center
        contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
}
