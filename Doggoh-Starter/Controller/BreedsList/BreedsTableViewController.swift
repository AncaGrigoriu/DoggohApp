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
    func configImage(with data: Data)
}

class BreedsTableViewController: UITableViewController {
    
    var activityIndicator: UIActivityIndicatorView!
    
    var coordinator: BreedsCoordinator!
    
    var viewmodel: BreedsViewModel? {
        didSet {
            viewmodel!.dataLoaded = reloadData
            viewmodel!.imageLoaded = refreshCell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinator = BreedsCoordinator(forViewController: self)
        coordinator.flowDelegate = self
        
        registerCell(Constants.multipleSubBreedsCellIdentifier)
        registerCell(Constants.singleSubBreedCellIdentifier)
        
        registerHeaderFooter(Constants.footerIdentifier)
        registerHeaderFooter(Constants.headerIdentifier)
        
        tableView.rowHeight = 56
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (viewmodel?.numberOfBreeds() ?? 0) == 0 {
            addActivityIndicator()
        }
    }
    
    private func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .gray)
        let frame = view.frame
        activityIndicator.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func reloadData() {
        self.activityIndicator.stopAnimating()
        self.tableView.reloadData()
    }
    
    private func refreshCell(_ indexPath: IndexPath) {
        let visibleIndexPaths = self.tableView.visibleCells.map { currentCell in
            return self.tableView.indexPath(for: currentCell)
        }
        if visibleIndexPaths.contains(indexPath) {
            let cell = self.tableView.cellForRow(at: indexPath) as! CellConfigurable
            self.viewmodel!.update(cell: cell, atIndexPath: indexPath)
        }
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel?.numberOfSubBreeds(forSection: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewmodel!.isSingleBreed(atIndexPath: indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.singleSubBreedCellIdentifier, for: indexPath) as! BreedTableViewCell
            cell.viewmodel = viewmodel!.breedViewModel(atIndexPath: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.multipleSubBreedsCellIdentifier, for: indexPath) as! SubBreedTableViewCell
            cell.viewmodel = viewmodel!.subBreedViewModel(atIndexPath: indexPath)
            return cell
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewmodel?.numberOfBreeds() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerIdentifier) as! DogsTableViewHeader
        
        sectionHeader.viewmodel = viewmodel!.headerViewModel(forSection: section)
        
        return sectionHeader
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.footerIdentifier) as! DogsTableViewFooter
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewmodel!.shouldHeaderBeVisible(forSection: section) {
            let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerIdentifier) as! DogsTableViewHeader
            return sectionHeader.frame.height
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if viewmodel!.isLastSection(currentSection: section) {
            return 0
        }
        
        let sectionFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.footerIdentifier) as! DogsTableViewFooter
        return sectionFooter.frame.height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let photo = breed.photo {
//            DogImagesRepository.checkBreedMatch(with: photo as Data) { response in
//                switch response {
//                case .failure(let error):
//                    print("error: \(error)")
//                case .success(let result):
//                    print(result)
//                    if result.contains(breed.generalBreedName.lowercased()) {
//                        print("Photo matches breed")
//                    } else {
//                        print("Photo does not match breed")
//                    }
//                }
//            }
//        }
        coordinator.onRowSelected(atIndexPath: indexPath)
    }
}

extension BreedsTableViewController: BreedsFlowDelegate {
    func showBreedDetails(withViewController viewController: BreedDetailsViewController) {
        self.navigationController!.pushViewController(viewController, animated: true)
    }
}

