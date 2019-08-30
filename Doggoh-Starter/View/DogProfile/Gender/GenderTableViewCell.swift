//
//  GenderTableViewCell.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class GenderTableViewCell: UITableViewCell {

    @IBOutlet weak var maleButton: DogDescriptionButton!
    @IBOutlet weak var femaleButton: DogDescriptionButton!
    
    var currentlySelectedButton: DogDescriptionButton!
    let userDefaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let index = userDefaults.integer(forKey: DogProfileConstants.genderKey)
        if index == 0 {
            currentlySelectedButton = maleButton
        } else {
            currentlySelectedButton = getGenderButton(index)
        }
        currentlySelectedButton.configure(withType: .selected)
    }
    
    @IBAction func genderButtonWasClicked(_ sender: DogDescriptionButton) {
        currentlySelectedButton.configure(withType: .unselected)
        currentlySelectedButton = sender
        currentlySelectedButton.configure(withType: .selected)
        setGender(sender)
    }
    
    private func setGender(_ sender: DogDescriptionButton) {
        let genderIndex = getGenderIndex(sender)
        userDefaults.set(genderIndex, forKey: DogProfileConstants.genderKey)
    }
    
    private func getGenderIndex(_ sender: DogDescriptionButton) -> Int {
        switch sender {
        case maleButton:
            return 1
        default:
            return 2
        }
    }
    
    private func getGenderButton(_ index: Int) -> DogDescriptionButton {
        switch index {
        case 1:
            return maleButton
        default:
            return femaleButton
        }
    }
    
    
}
