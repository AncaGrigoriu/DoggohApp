//
//  BreedDetailsViewModel.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct BreedDetailsViewModel {
    private let breed: Breed
    private let breedIndexPath: IndexPath
    let photosCount = 4
    let navigationBarTitleString: String
    
    var onImagesLoaded: (() -> Void)?
    
    init(breed: Breed, atIndexPath breedIndexPath: IndexPath) {
        self.breed = breed
        self.breedIndexPath = breedIndexPath
        
        let isSingularBreed = (breed.specificBreedName.lowercased() == breed.generalBreedName.lowercased())
        let subBreedNameValue = !isSingularBreed ? "\(breed.specificBreedName.uppercased()) " : ""
        let breedName = breed.generalBreedName.uppercased()
        navigationBarTitleString = "\(subBreedNameValue)\(breedName)"
    }
    
    func numberOfImages() -> Int {
        if let breeds = breed.breedPhotos,
            breeds.count == 0 {
            getImagesForBreed()
        }
        
        return breed.breedPhotos?.count ?? 0
    }
    
    func cellViewModel(atIndexPath indexPath: IndexPath) -> BreedDetailsTableViewCellViewModel {
        let breedImage = breed.breedPhotos?.allObjects[indexPath.row] as! BreedImage
        let viewModel = BreedDetailsTableViewCellViewModel(imageData: breedImage.image as Data)
        return viewModel
    }
    
    private func getImagesForBreed() {
        DogImagesRepository.getImages(for: breed, withCount: photosCount) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("error: \(error)")
                case .success(_):
                    if let dogImages = self.breed.breedPhotos,
                        dogImages.count > 0 {
                        self.onImagesLoaded?()
                    }
                }
            }
        }
    }
}
