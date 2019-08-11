//
//  DogPictureTableViewCell.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

protocol DogPictureTableViewCellDelegate: class {
    func keyboardWillShow(notification: NSNotification, currentTextField: UITextField)
    func keyboardWillHide(notification: NSNotification)
}

@IBDesignable
class DogPictureTableViewCell: UITableViewCell {
    
    var activeTextField: UITextField!
    
    let breeds: [String] = getBreeds()
    var breedIndex: Int = 0
    var picker: UIPickerView!
    
    weak var delegate: DogPictureTableViewCellDelegate?
    
    @IBOutlet weak var dogBreedTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activeTextField = nil
        configureTextField()
    }
    
    private func configureTextField() {
        let rightViewImage = UIImage(named: "path")
        let rightViewImageView = UIImageView(image: rightViewImage)
        dogBreedTextField.rightView = rightViewImageView
        dogBreedTextField.rightViewMode = .always
        dogBreedTextField.text = breeds[breedIndex]
        
        configureInputView()
        configureInputAccesoryView()
        addInputNotifications()
    }
    
    private func configureInputView() {
        picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        dogBreedTextField.inputView = picker
    }
    
    private func configureInputAccesoryView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveButtonClicked))
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonClicked))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([saveBarButton, flexibleSpace, cancelBarButton], animated: true)
        
        dogBreedTextField.inputAccessoryView = toolbar
    }
    
    @objc func saveButtonClicked() {
        breedIndex = picker.selectedRow(inComponent: 0)
        dogBreedTextField.resignFirstResponder()
    }
    
    @objc func cancelButtonClicked() {
        dogBreedTextField.text = breeds[breedIndex]
        dogBreedTextField.resignFirstResponder()
    }
    
    private func addInputNotifications() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillShow(notification:)),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillHide(notification:)),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        picker.selectRow(breedIndex, inComponent: 0, animated: false)
        dogBreedTextField.alpha = 0.5
        delegate?.keyboardWillShow(notification: notification, currentTextField: dogBreedTextField)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        dogBreedTextField.alpha = 1.0
        delegate?.keyboardWillHide(notification: notification)
    }
    
    private static func getBreeds() -> [String] {
        var result = [String]()
        if let data = BreedsRepository.dataFromJSON(withName: BreedsRepository.filename),
            let jsonData = data["message"] as? [String:[String]] {
            jsonData.forEach { generalBreed, specificBreeds in
                specificBreeds.forEach { breedName in
                    result.append("\(breedName.capitalized) \(generalBreed.capitalized)")
                }
                
                if specificBreeds.count == 0 {
                    result.append(generalBreed.capitalized)
                }
            }
        }
        return result.sorted()
    }
}

extension DogPictureTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dogBreedTextField.text = breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
}

extension DogPictureTableViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
}
