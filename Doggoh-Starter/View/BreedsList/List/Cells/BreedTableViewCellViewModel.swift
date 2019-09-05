//
//  BreedTableViewCellViewModel.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct BreedTableViewCellViewModel {
    let breedImageData: Data?
    let breedNameString: String
    
    init(withBreed breed: Breed) {
        breedImageData = breed.photo as Data?
        breedNameString = breed.specificBreedName
    }
}
