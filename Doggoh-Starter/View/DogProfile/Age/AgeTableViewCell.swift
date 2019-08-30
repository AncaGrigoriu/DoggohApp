//
//  AgeTableViewCell.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

protocol AgeTableViewCellDelegate: class {
    func onAgeButtonClicked()
}

class AgeTableViewCell: UITableViewCell {
    
    weak var delegate: AgeTableViewCellDelegate?

    @IBOutlet weak var lessThanOneYearButton: DogDescriptionButton!
    @IBOutlet weak var betweenOneAndTwoYearsButton: DogDescriptionButton!
    @IBOutlet weak var moreThanTwoYearsButton: DogDescriptionButton!
    
    var currentlySelectedButton: DogDescriptionButton!
    let userDefaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let index = userDefaults.integer(forKey: DogProfileConstants.ageKey)
        if index == 0 {
            currentlySelectedButton = lessThanOneYearButton
        } else {
            currentlySelectedButton = getAgeButton(index)
        }
        currentlySelectedButton.configure(withType: .selected)
    }
    
    @IBAction func ageButtonClicked(_ sender: DogDescriptionButton) {
        currentlySelectedButton.configure(withType: .unselected)
        currentlySelectedButton = sender
        currentlySelectedButton.configure(withType: .selected)
        setAge(sender)
    }
    
    private func setAge(_ sender: DogDescriptionButton) {
        let ageIndex = getAgeIndex(sender)
        userDefaults.set(ageIndex, forKey: DogProfileConstants.ageKey)
    }
    
    private func getAgeIndex(_ sender: DogDescriptionButton) -> Int {
        switch sender {
        case lessThanOneYearButton:
            return 1
        case betweenOneAndTwoYearsButton:
            return 2
        default:
            return 3
        }
    }
    
    private func getAgeButton(_ index: Int) -> DogDescriptionButton {
        switch index {
        case 1:
            return lessThanOneYearButton
        case 2:
            return betweenOneAndTwoYearsButton
        default:
            return moreThanTwoYearsButton
        }
    }
}
