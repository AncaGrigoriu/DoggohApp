//
//  DashboardViewController.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit
import CoreData

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
    
    var fetchRC: NSFetchedResultsController<Breed>?
    
    var imagesDispatch = DispatchQueue(label: "images", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell(Constants.multipleSubBreedsCellIdentifier)
        registerCell(Constants.singleSubBreedCellIdentifier)
        
        registerHeaderFooter(Constants.footerIdentifier)
        registerHeaderFooter(Constants.headerIdentifier)
        
        tableView.rowHeight = 56
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addActivityIndicator()
        getDogsData()
    }
    
    private func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .gray)
        let frame = view.frame
        activityIndicator.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
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
        BreedsRepository.getBreedList { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let breeds):
                self.fetchRC = breeds
                self.fetchRC?.delegate = self
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    func getBreedImage(forIndexPath indexPath: IndexPath, cell: CellConfigurable) {
        let breed = fetchRC!.object(at: indexPath)
        let generalBreed = breed.generalBreedName
        DogImagesRepository.getRandomImage(forBreed: generalBreed.lowercased()) { result in
            switch result {
            case .success(let imageUrl):
                self.imagesDispatch.async {
                    do {
                        let data = try Data(contentsOf: URL(string: imageUrl)!)
                        
                        DispatchQueue.main.async {
                            breed.photo = data as NSData
                            BreedsRepository.updateBreed(at: indexPath, with: breed)
                            
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
        guard let breed = fetchRC?.object(at: indexPath), breed.photo != nil else {
            getBreedImage(forIndexPath: indexPath, cell: cell)
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchRC?.sections,
            let subbreeds = sections[section].objects else { return 0 }
        return subbreeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dog = fetchRC!.object(at: indexPath)
       
        if dog.generalBreedName == dog.specificBreedName {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.singleSubBreedCellIdentifier, for: indexPath) as! BreedTableViewCell
            cell.config(with: dog)
            
            indexPathImage(for: indexPath, cell: cell as CellConfigurable)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.multipleSubBreedsCellIdentifier, for: indexPath) as! SubBreedTableViewCell
            cell.config(with: dog)
            
            indexPathImage(for: indexPath, cell: cell as CellConfigurable)
            
            return cell
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
         return fetchRC?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerIdentifier) as! DogsTableViewHeader
        
        guard let sections = fetchRC?.sections,
            let subbreeds = sections[section].objects as? [Breed] else { return sectionHeader }
        
        let breed = subbreeds[0].generalBreedName
        
        if subbreeds.count > 1 || subbreeds[0].specificBreedName != breed {
            sectionHeader.headerTextLabel.text = breed
        }
        
        return sectionHeader
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.footerIdentifier) as! DogsTableViewFooter
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sections = fetchRC?.sections,
            let subbreeds = sections[section].objects as? [Breed] else { return 0 }
        
        let breed = subbreeds[0].generalBreedName
        
        if subbreeds.count > 1 || subbreeds[0].specificBreedName != breed {
            let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerIdentifier) as! DogsTableViewHeader
            return sectionHeader.frame.height
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let sections = fetchRC?.sections,
            section == sections.count - 1 {
            return 0
        }
        
        let sectionFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.footerIdentifier) as! DogsTableViewFooter
        return sectionFooter.frame.height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let breed = fetchRC!.object(at: indexPath)
        
        if let photo = breed.photo {
            DogImagesRepository.checkBreedMatch(with: photo as Data) { response in
                switch response {
                case .failure(let error):
                    print("error: \(error)")
                case .success(let result):
                    print(result)
                    if result.contains(breed.generalBreedName.lowercased()) {
                        print("Photo matches breed")
                    } else {
                        print("Photo does not match breed")
                    }
                }
            }
        }
        
        let breedDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "BreedDetailsViewController") as! BreedDetailsViewController
        
        breedDetailsViewController.breed = breed
        breedDetailsViewController.breedIndexPath = indexPath
        self.navigationController!.pushViewController(breedDetailsViewController, animated: true)
    }
}

extension BreedsTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else { return }
        switch type {
        case .insert:
            tableView.insertRows(at: [cellIndex], with: .automatic)
        default:
            break
        }
        
    }
}

