//
//  BreedsTableViewDataSource.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class BreedsTableViewDataSource: NSObject, UITableViewDataSource {
    
    var generalBreeds = [String]()
    var dogs = [Breed]()
    var groupedDogs = [String:[Breed]]()
    
    override init() {
        super.init()
        getDogsData()
        groupDogs()
    }
    
    private func getDogsData() {
        if let data = BreedsRepository.dataFromJSON(withName: BreedsRepository.filename),
            let jsonData = data["message"] as? [String:[String]] {
                var imageIndex = 0
                jsonData.forEach { generalBreed, specificBreeds in
                    generalBreeds.append(generalBreed)
                    
                    if imageIndex == 23 {
                        imageIndex = 0
                    }
                    
                    specificBreeds.forEach { breedName in
                        let image = UIImage() //UIImage(named: String(imageIndex))!
                        dogs.append(Breed(generalBreedName: generalBreed, specificBreedName: breedName, photo: image))
                        imageIndex += 1
                    }
                    
                    if specificBreeds.count == 0 {
                        let image = UIImage() //UIImage(named: String(imageIndex))!
                        dogs.append(Breed(generalBreedName: generalBreed, specificBreedName: generalBreed, photo: image))
                        imageIndex += 1
                    }
                }
            }
    }
    
    private func groupDogs() {
        for dog in dogs {
            let key = dog.generalBreedName
            if var dogList = groupedDogs[key] {
                dogList.append(dog)
                groupedDogs[key] = dogList
            } else {
                groupedDogs[key] = [dog]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let breed = generalBreeds[section]
        
        return groupedDogs[breed]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let generalBreed = generalBreeds[indexPath.section]
        
        if let dog = groupedDogs[generalBreed]?[indexPath.row] {
            if dog.generalBreedName == dog.specificBreedName {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.singleSubBreedCellIdentifier, for: indexPath) as! BreedTableViewCell
                cell.config(with: dog)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.singleSubBreedCellIdentifier, for: indexPath) as! SubBreedTableViewCell
                cell.config(with: dog)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return generalBreeds.count
    }
    
}
