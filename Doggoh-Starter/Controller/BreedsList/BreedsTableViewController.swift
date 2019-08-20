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

protocol CellConfigurable {
    func config(with dog: Breed)
}

class BreedsTableViewController: UITableViewController {
        
    var generalBreeds = [String]()
    var groupedBreeds = [String:[Breed]]()
    var images = [IndexPath: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell(Constants.multipleSubBreedsCellIdentifier)
        registerCell(Constants.singleSubBreedCellIdentifier)
        
        registerHeaderFooter(Constants.footerIdentifier)
        registerHeaderFooter(Constants.headerIdentifier)
        
        tableView.rowHeight = 56
        tableView.separatorStyle = .none
        
        getDogsData()
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
        BreedsRepository.getDogs { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let breeds):
                var generalBreedsSet = Set<String>()
                breeds.forEach { breed in
                    generalBreedsSet.insert(breed.generalBreedName)
                    if var currentSubBreeds = self.groupedBreeds[breed.generalBreedName] {
                        currentSubBreeds.append(breed)
                        self.groupedBreeds[breed.generalBreedName] = currentSubBreeds
                    } else {
                        self.groupedBreeds[breed.generalBreedName] = [breed]
                    }
                }
                generalBreedsSet.forEach{ breed in
                    self.generalBreeds.append(breed)
                }
        
                self.generalBreeds = self.generalBreeds.sorted()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getBreedImage(forIndexPath indexPath: IndexPath, cell: CellConfigurable) {
        print("Retrieving image for indexPath \(indexPath)")
        let generalBreed = generalBreeds[indexPath.section]
        var breed = groupedBreeds[generalBreed]![indexPath.row]
        DogImagesRepository.getRandomImage(forBreed: generalBreed.lowercased()) { result in
            switch result {
            case .success(let imageUrl):
                print("Success for indexPath \(indexPath)")
                do {
                    let data = try Data(contentsOf: URL(string: imageUrl)!)
                    let image = UIImage(data: data)!
                    self.images[indexPath] = image
                    DispatchQueue.main.async {
                        breed.photo = image
                        self.groupedBreeds[generalBreed]![indexPath.row] = breed
                        cell.config(with: breed)
                    }
                }
                catch let error {
                    print("error: \(error)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func indexPathImage(for indexPath: IndexPath, cell: CellConfigurable) {
        guard let image = images[indexPath] else {
            print("Index path \(indexPath) has no image")
            images[indexPath] = UIImage()
            getBreedImage(forIndexPath: indexPath, cell: cell)
            return
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
                
                if let cellConfigurable = cell as? CellConfigurable {
                    indexPathImage(for: indexPath, cell: cellConfigurable)
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.multipleSubBreedsCellIdentifier, for: indexPath) as! SubBreedTableViewCell
                cell.config(with: dog)
                
                if let cellConfigurable = cell as? CellConfigurable {
                    indexPathImage(for: indexPath, cell: cellConfigurable)
                }
                
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generalBreed = generalBreeds[indexPath.section]
        if let subBreeds = groupedBreeds[generalBreed] {
            let breed = subBreeds[indexPath.row]
            let breedDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "BreedDetailsViewController") as! BreedDetailsViewController
            if breed.generalBreedName == breed.specificBreedName {
                breedDetailsViewController.breedName = breed.specificBreedName
            } else {
                breedDetailsViewController.breedName = "\(breed.specificBreedName) \(breed.generalBreedName)"
            }
            
            self.navigationController!.pushViewController(breedDetailsViewController, animated: true)
        }
    }
}
