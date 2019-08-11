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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        maleButton.configure(withType: .selected)
        currentlySelectedButton = maleButton
    }
    
    @IBAction func genderButtonWasClicked(_ sender: DogDescriptionButton) {
        currentlySelectedButton.configure(withType: .unselected)
        currentlySelectedButton = sender
        currentlySelectedButton.configure(withType: .selected)
    }
    
    
}
