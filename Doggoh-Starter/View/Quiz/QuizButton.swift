//
//  QuizButton.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

enum QuizButtonType {
    case multipleOptions
    case action
    
    var height: CGFloat {
        return 50.0
    }
    var cornerRadius: CGFloat {
        return height / 2
    }
    var backgroundColorDefault: CGColor {
        switch self {
        case .multipleOptions:
            return UIColor.white.cgColor
        default:
            return (UIColor.init(named: "actionButtonOrange") ?? UIColor.orange).cgColor
        }
    }
    var backgroundColorSelected: CGColor {
        switch self {
        case .multipleOptions:
            return (UIColor.init(named: "optionButtonBorder") ?? UIColor.gray).cgColor
        default:
            return (UIColor.init(named: "actionButtonOrange") ?? UIColor.orange).cgColor
        }
    }
    var backgroundColorDisabled: CGColor {
        switch self {
        case .multipleOptions:
            return UIColor.white.cgColor
        default:
            return (UIColor.init(named: "actionButtonDisabled") ?? UIColor.orange).cgColor
        }
    }
    var textColorDefault: UIColor {
        switch self {
        case .multipleOptions:
            return UIColor.init(named: "optionButtonText") ?? UIColor.gray
        default:
            return UIColor.white
        }
    }
    var textColorSelected: UIColor {
        switch self {
        case .multipleOptions:
            return (UIColor.init(named: "actionButtonOrange") ?? UIColor.orange)
        default:
            return UIColor.white
        }
    }
    var borderWidth: CGFloat {
        switch self {
        case .multipleOptions:
            return 1
        default:
            return 0
        }
    }
    var borderColor: CGColor {
        switch self {
        case .multipleOptions:
            return (UIColor.init(named: "optionButtonBorder") ?? UIColor.gray).cgColor
        default:
            return (UIColor.init(named: "actionButtonOrange") ?? UIColor.orange).cgColor
        }
    }
}

class QuizButton: UIButton {
    
    private var quizButtonType: QuizButtonType!
    
    func configure(withType type: QuizButtonType, withTitle title: String) {
        setTitle(title, for: .normal)
        setTitleColor(type.textColorDefault, for: .normal)
        
        heightAnchor.constraint(greaterThanOrEqualToConstant: type.height).isActive = true
        layer.masksToBounds = true
        layer.cornerRadius = type.cornerRadius
        layer.borderWidth = type.borderWidth
        layer.borderColor = type.borderColor
        layer.backgroundColor = type.backgroundColorDefault
    
        titleLabel?.font = UIFont(name: "Montserrat", size: 14)!
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = NSTextAlignment.center
        
        quizButtonType = type
    }
    
    func update(forState state: UIControl.State) {
        switch state {
        case .highlighted:
            setTitleColor(quizButtonType.textColorSelected, for: .normal)
            layer.backgroundColor = quizButtonType.backgroundColorSelected
        case .disabled:
            setTitleColor(quizButtonType.textColorDefault, for: .disabled)
            layer.backgroundColor = quizButtonType.backgroundColorDisabled
        default:
            setTitleColor(quizButtonType.textColorDefault, for: .normal)
            layer.backgroundColor = quizButtonType.backgroundColorDefault
        }
    }
}
