//
//  CharacterTableViewCell.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var characteristics = ["QUIET", "PLAYFUL", "PEACEFUL", "CHERRFUL", "LOUD",                           "FRIENDLY", "ACTIVE", "CURIOUS", "AFFECTIONATE",
                           "TRAINED", "INTELLIGENT", "SENSITIVE", "SOCIABLE"]
    
    let lateralMargin: CGFloat = 27
    let verticalMarginTop: CGFloat = 0
    let verticalMarginBottom: CGFloat = 16
    
    let characterCellReusableIdentifier = "CharacterCollectionViewCell"
    
    var selectedItems = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCell(characterCellReusableIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.allowsMultipleSelection = true
        
        collectionView.contentInset = UIEdgeInsets(top: verticalMarginTop, left: lateralMargin, bottom: verticalMarginBottom, right: lateralMargin)
        
        if let layout = collectionView.collectionViewLayout as? DogProfileCharacterLayout {
            layout.delegate = self
        }
    }
    
    func registerCell(_ identifier: String) {
        collectionView.register(UINib(nibName: characterCellReusableIdentifier, bundle: Bundle.main), forCellWithReuseIdentifier: characterCellReusableIdentifier)
    }
}

extension CharacterTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characteristics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let characteristic = characteristics[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: characterCellReusableIdentifier, for: indexPath) as! CharacterCollectionViewCell
        
        cell.characteristicLabel.text = characteristic
        
        if(selectedItems.contains(characteristic)) {
            cell.isSelected = true
        }
        
        return cell
    }
}

extension CharacterTableViewCell: DogProfileCharacterDelegate {
    func collectionView(_ collectionView: UICollectionView, widthForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        let labelText = characteristics[indexPath.item]
        let font = UIFont(name: "Montserrat", size: 14)!
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = labelText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(labelSize.width)
    }
}

extension CharacterTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let characteristic = characteristics[indexPath.row]
        selectedItems.append(characteristic)
    }
}
