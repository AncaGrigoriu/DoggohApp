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
    
    var originalOffset: CGPoint?
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: dogPhotoReusableCellIdentifier, for: indexPath) as! DogPictureTableViewCell
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ageReusableCellIdentifier, for: indexPath) as! AgeTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: genderReusableCellIdentifier, for: indexPath) as! GenderTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: characterReusableCellIdentifier, for: indexPath) as! CharacterTableViewCell
            return cell
        }
    }
}

extension DogProfileTableViewController: DogPictureTableViewCellDelegate {
    func keyboardWillShow(notification: NSNotification, currentTextField: UITextField) {
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let textFieldFrame = currentTextField.frame
        let offsetRect = CGRect(origin: tableView.contentOffset, size: tableView.bounds.size)
        let visibleRect = CGRect(x: offsetRect.minX, y: offsetRect.minY, width: offsetRect.width, height: offsetRect.height - keyboardFrame.height)
        
        if !visibleRect.contains(textFieldFrame) {
            originalOffset = tableView.contentOffset
            tableView.setContentOffset(CGPoint(x: offsetRect.minX, y: offsetRect.minY + keyboardFrame.height), animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let unwrappedOffset = originalOffset {
            tableView.setContentOffset(unwrappedOffset, animated: true)
            originalOffset = nil
        }
    }
}
