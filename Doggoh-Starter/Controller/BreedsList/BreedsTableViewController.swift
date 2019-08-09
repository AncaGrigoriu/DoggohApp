//
//  DashboardViewController.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

struct Constants {
    static let multipleSubBreedsCellIdentifier = "SubBreedTableViewCell"
    static let singleSubBreedCellIdentifier = "BreedTableViewCell"
    static let footerIdentifier = "DogsTableViewFooter"
    static let headerIdentifier = "DogsTableViewHeader"
}

class BreedsTableViewController: UITableViewController {
    
    var allBreeds = [Breed]()
    var generalBreeds = [String]()
    var groupedBreeds = [String:[Breed]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell(Constants.multipleSubBreedsCellIdentifier)
        registerCell(Constants.singleSubBreedCellIdentifier)
        
        registerHeaderFooter(Constants.footerIdentifier)
        registerHeaderFooter(Constants.headerIdentifier)
        
        tableView.rowHeight = 56
        tableView.separatorStyle = .none
        
        getDogsData()
        groupDogs()
    }
    
    func registerCell(_ reuseId: String) {
        let nib = UINib(nibName: reuseId, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: reuseId)
    }

    func registerHeaderFooter(_ reuseId: String) {
        let nib = UINib(nibName: reuseId, bundle: Bundle.main)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: reuseId)
    }
}

extension BreedsTableViewController {
    func getDogsData() {
        if let data = BreedsRepository.dataFromJSON(withName: BreedsRepository.filename),
            let jsonData = data["message"] as? [String:[String]] {
            var imageIndex = 0
            jsonData.forEach { generalBreed, specificBreeds in
                generalBreeds.append(generalBreed.uppercased())
                
                specificBreeds.forEach { breedName in
                    if imageIndex == 23 {
                        imageIndex = 0
                    }
                    let image = UIImage(named: String(imageIndex)) ?? UIImage()
                    allBreeds.append(Breed(generalBreedName: generalBreed.uppercased(), specificBreedName: breedName.capitalized, photo: image))
                    imageIndex += 1
                }
                
                if specificBreeds.count == 0 {
                    if imageIndex == 23 {
                        imageIndex = 0
                    }
                    let image = UIImage(named: String(imageIndex)) ?? UIImage()
                    allBreeds.append(Breed(generalBreedName: generalBreed.uppercased(), specificBreedName: generalBreed.uppercased(), photo: image))
                    imageIndex += 1
                }
            }
        }
    }
    
    func groupDogs() {
        for dog in allBreeds {
            let key = dog.generalBreedName
            if var dogList = groupedBreeds[key] {
                dogList.append(dog)
                groupedBreeds[key] = dogList
            } else {
                groupedBreeds[key] = [dog]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let breed = generalBreeds[section]
        
        return groupedBreeds[breed]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let generalBreed = generalBreeds[indexPath.section]
        
        if let dog = groupedBreeds[generalBreed]?[indexPath.row] {
            if dog.generalBreedName == dog.specificBreedName {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.singleSubBreedCellIdentifier, for: indexPath) as! BreedTableViewCell
                cell.config(with: dog)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.multipleSubBreedsCellIdentifier, for: indexPath) as! SubBreedTableViewCell
                cell.config(with: dog)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return generalBreeds.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let breed = generalBreeds[section]
        let dogsOfBreed = groupedBreeds[breed]!
        
        let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerIdentifier) as! DogsTableViewHeader
        sectionHeader.backgroundColor = UIColor.white
        
        if dogsOfBreed.count > 1 || dogsOfBreed[0].specificBreedName != breed {
            sectionHeader.headerTextLabel.text = breed
        }
        
        return sectionHeader
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.footerIdentifier) as! DogsTableViewFooter
    }
   
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let breed = generalBreeds[section]
        let dogsOfBreed = groupedBreeds[breed]!
        
        if dogsOfBreed.count > 1 || dogsOfBreed[0].specificBreedName != breed {
            let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerIdentifier) as! DogsTableViewHeader
            return sectionHeader.frame.height
        }
        
        return 0
    }
}
