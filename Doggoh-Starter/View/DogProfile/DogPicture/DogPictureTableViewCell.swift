//
//  DogPictureTableViewCell.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

@IBDesignable
class DogPictureTableViewCell: UITableViewCell {

    let breeds: [String] = getBreeds()
    var breed: String!
    
    @IBOutlet weak var dogBreedTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        breed = breeds[0]
        configureTextField()
    }
    
    private func configureTextField() {
        let rightViewImage = UIImage(named: "path")
        let rightViewImageView = UIImageView(image: rightViewImage)
        dogBreedTextField.rightView = rightViewImageView
        dogBreedTextField.rightViewMode = .always
        dogBreedTextField.text = breed
    }
    
    private func configureInputView() {
        let picker = UIPickerView()
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
        
        dueDateTextField.inputAccessoryView = toolbar
    }
    
    @objc func saveButtonClicked() {
        
    }
    
    @objc func cancelButtonClicked() {
        
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
        return result
    }
}

extension DogPictureTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dogBreedTextField.text = breeds[row]
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
