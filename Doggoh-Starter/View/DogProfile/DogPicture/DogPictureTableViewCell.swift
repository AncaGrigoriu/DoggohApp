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
    
    var breeds: [String] = []
    var breedIndex: Int = 0
    var picker: UIPickerView!
    let userDefaults = UserDefaults.standard
    
    weak var delegate: DogPictureTableViewCellDelegate?
    
    @IBOutlet weak var dogBreedTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        getBreeds()
        activeTextField = nil
        configureTextField()
    }
    
    private func configureTextField() {
        let rightViewImage = UIImage(named: "path")
        let rightViewImageView = UIImageView(image: rightViewImage)
        dogBreedTextField.rightView = rightViewImageView
        dogBreedTextField.rightViewMode = .always
        
        if let breed = userDefaults.string(forKey: DogProfileConstants.breedKey) {
            dogBreedTextField.text = breed
        } else {
            if breeds.count > 0 {
                dogBreedTextField.text = breeds[breedIndex]
            }
        }
        
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
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonClicked))
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonClicked))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelBarButton, flexibleSpace, saveBarButton], animated: true)
        
        dogBreedTextField.inputAccessoryView = toolbar
    }
    
    @objc func saveButtonClicked() {
        breedIndex = picker.selectedRow(inComponent: 0)
        userDefaults.set(dogBreedTextField.text, forKey: DogProfileConstants.breedKey)
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
    
    private func getBreeds() {
        BreedsRepository.getBreedList { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let breeds):
                    breeds.fetchedObjects?.forEach { breed in
                        let breedName = breed.generalBreedName.lowercased()
                        let subBreedName = breed.specificBreedName.lowercased()
                        if breedName == subBreedName {
                            self.breeds.append(breedName.capitalized)
                        } else {
                            self.breeds.append("\(subBreedName.capitalized) \(breedName.capitalized)")
                        }
                    }
                }
            }
        }
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
