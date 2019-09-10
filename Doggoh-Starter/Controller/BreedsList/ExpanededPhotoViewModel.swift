//
//  ExpanededPhotoViewModel.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 04/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct ExpanededPhotoViewModel {
    let breed: Breed
    var currentPhotoIndex: Int
    
    init(withBreed breed: Breed, andCurrentIndex currentIndex: Int) {
        self.breed = breed
        self.currentPhotoIndex = currentIndex
    }
    
    func numberOfPhotos() -> Int {
        return breed.breedPhotos!.count
    }
    
    func cellViewModel(atIndexPath indexPath: IndexPath) -> MaximizedDogPhotoViewModel {
        let breedImage = breed.breedPhotos?.allObjects[indexPath.row] as! BreedImage
        let viewModel = MaximizedDogPhotoViewModel(imageData: breedImage.image as Data)
        return viewModel
    }
}
