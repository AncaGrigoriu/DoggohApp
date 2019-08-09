//
//  DogProfileTableViewController.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class DogProfileTableViewController: UITableViewController {

    let dogPhotoReusableCellIdentifier = "DogPictureTableViewCell"
    let ageReusableCellIdentifier = "AgeTableViewCell"
    let genderReusableCellIdentifier = "GenderTableViewCell"
    let characterReusableCellIdentifier = "CharacterTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func registerCells() {
        registerReusableCell(dogPhotoReusableCellIdentifier)
        registerReusableCell(ageReusableCellIdentifier)
        registerReusableCell(genderReusableCellIdentifier)
        registerReusableCell(characterReusableCellIdentifier)
    }

    func registerReusableCell(_ identifier: String) {
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: dogPhotoReusableCellIdentifier, for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ageReusableCellIdentifier, for: indexPath)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: genderReusableCellIdentifier, for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: characterReusableCellIdentifier, for: indexPath)
            return cell
        }
    }
    

}
