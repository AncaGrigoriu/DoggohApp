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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lessThanOneYearButton.configure(withType: .selected)
        currentlySelectedButton = lessThanOneYearButton
    }
    
    @IBAction func ageButtonClicked(_ sender: DogDescriptionButton) {
        currentlySelectedButton.configure(withType: .unselected)
        currentlySelectedButton = sender
        currentlySelectedButton.configure(withType: .selected)
    }
}
