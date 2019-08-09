//
//  ThirdViewController.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class DogProfileViewController: UIViewController {

    var ageButton: DogDescriptionButton!
    var genderButton: DogDescriptionButton!
    
    @IBOutlet weak var lessThanOneButton: DogDescriptionButton!
    
    @IBOutlet weak var maleButton: DogDescriptionButton!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ageButton = lessThanOneButton
        genderButton = maleButton
    
        ageButton.configure(withType: .selected)
        genderButton.configure(withType: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationBar.barTintColor = UIColor.white
        navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func ageButtonSelected(_ sender: DogDescriptionButton) {
        ageButton.configure(withType: .unselected)
        ageButton = sender
        ageButton.configure(withType: .selected)
    }
    
    
    @IBAction func genderButtonSelected(_ sender: DogDescriptionButton) {
        genderButton.configure(withType: .unselected)
        genderButton = sender
        genderButton.configure(withType: .selected)
    }
    
    
    @IBAction func characterButtonSelected(_ sender: DogDescriptionButton) {
        if sender.buttonState == .unselected {
            sender.configure(withType: .selected)
        } else {
            sender.configure(withType: .unselected)
        }
    }
    
}
