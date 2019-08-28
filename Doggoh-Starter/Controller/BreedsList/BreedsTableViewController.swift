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
    
    var imagesDispatch = DispatchQueue(label: "images", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
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
        let generalBreed = generalBreeds[indexPath.section]
        var breed = groupedBreeds[generalBreed]![indexPath.row]
        DogImagesRepository.getRandomImage(forBreed: generalBreed.lowercased()) { result in
            switch result {
            case .success(let imageUrl):
                self.imagesDispatch.async {
                    do {
                        let data = try Data(contentsOf: URL(string: imageUrl)!)
                        let image = UIImage(data: data)!
                        
                        DispatchQueue.main.async {
                            self.images[indexPath] = image
                            breed.photo = image
                            self.groupedBreeds[generalBreed]![indexPath.row] = breed
                            
                            let visibleIndexPaths = self.tableView.visibleCells.map { currentCell in
                                return self.tableView.indexPath(for: currentCell)
                            }
                            if visibleIndexPaths.contains(indexPath) {
                                cell.config(with: breed)
                            }
                        }
                    }
                    catch let error {
                        print("error: \(error)")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func indexPathImage(for indexPath: IndexPath, cell: CellConfigurable) {
        guard images[indexPath] != nil else {
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
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == generalBreeds.count - 1 {
            return 0
        }
        
        let sectionFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.footerIdentifier) as! DogsTableViewFooter
        return sectionFooter.frame.height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generalBreed = generalBreeds[indexPath.section]
        
        if let image = images[indexPath], image.size != .zero {
            DogImagesRepository.checkBreedMatch(with: image) { response in
                switch response {
                case .failure(let error):
                    print("error: \(error)")
                case .success(let result):
                    print(result)
                    if result.contains(generalBreed.lowercased()) {
                        print("Photo matches breed")
                    } else {
                        print("Photo does not match breed")
                    }
                }
            }
        }
        
        if let subBreeds = groupedBreeds[generalBreed] {
            let breed = subBreeds[indexPath.row]
            let breedDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "BreedDetailsViewController") as! BreedDetailsViewController
            
            breedDetailsViewController.breedName = breed.generalBreedName
            if breed.generalBreedName != breed.specificBreedName {
                breedDetailsViewController.subBreedName = breed.specificBreedName
            }
            
            self.navigationController!.pushViewController(breedDetailsViewController, animated: true)
        }
    }
}
