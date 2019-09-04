//
//  BreedsCoordinator.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol BreedsFlowDelegate: class {
    func showBreedDetails(withViewController viewController: BreedDetailsViewController)
}

protocol BreedDetailsFlowDelegate: class {
    func showMaximizedPictures(withViewController viewController: ExpandedPhotosViewController)
    func goBack(_ imageIndex: Int)
}

class BreedsCoordinator {
    var currentlySelectedBreed: Breed?
    var breedsFetchRC: NSFetchedResultsController<Breed>!
    weak var flowDelegate: BreedsFlowDelegate?
    weak var detailsFlowDelegate: BreedDetailsFlowDelegate?
    
    init(forViewController viewController: BreedsTableViewController) {
        initBreedsVCViewModel(forViewController: viewController)
    }
    
    func onRowSelected(atIndexPath indexPath: IndexPath) {
        let breed = breedsFetchRC.object(at: indexPath)
        currentlySelectedBreed = breed
        if let breedDetailsVC = getBreedDetailsViewController(withBreed: breed, atIndexPath: indexPath) {
            flowDelegate?.showBreedDetails(withViewController: breedDetailsVC)
        }
    }
    
    func onImageSelected(atIndex index: Int) {
        if let expandedPhotosVC = getExpandedBreedPhotosViewController(atIndex: index) {
            detailsFlowDelegate?.showMaximizedPictures(withViewController: expandedPhotosVC)
        }
    }
    
    private func getExpandedBreedPhotosViewController(atIndex index: Int) -> ExpandedPhotosViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let expandedPhotosVC = storyboard.instantiateViewController(withIdentifier: "ExpandedPhotosViewController") as? ExpandedPhotosViewController
        
        expandedPhotosVC?.viewmodel = ExpanededPhotoViewModel(withBreed: currentlySelectedBreed!, andCurrentIndex: index)
        expandedPhotosVC?.onDismissCompletion = detailsFlowDelegate?.goBack
        
        return expandedPhotosVC
    }
    
    private func getBreedDetailsViewController(withBreed breed: Breed, atIndexPath indexPath: IndexPath) -> BreedDetailsViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let breedDetailsViewController = storyboard.instantiateViewController(withIdentifier: "BreedDetailsViewController") as? BreedDetailsViewController
        
        breedDetailsViewController?.viewmodel = BreedDetailsViewModel(breed: breed, atIndexPath: indexPath)
        breedDetailsViewController?.coordinator = self
        
        return breedDetailsViewController
    }
    
    private func initBreedsVCViewModel(forViewController viewController: BreedsTableViewController) {
        let viewmodel = BreedsViewModel()
        viewmodel.dataLoaded = {
            self.breedsFetchRC = viewmodel.breedsFetchRC
            viewController.viewmodel = viewmodel
        }
    }
}
