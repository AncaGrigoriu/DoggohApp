//
//  BreedDetailsViewController.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class BreedDetailsViewController: UIViewController {
    
    var breedName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = breedName
        configureNavigationBar()
        // Do any additional setup after loading the view.
    }

    func configureNavigationBar() {
        let backImage = UIImage(named: "backButton")
        let barButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        barButton.tintColor = UIColor(named: "backButtonColor")
        
        navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
