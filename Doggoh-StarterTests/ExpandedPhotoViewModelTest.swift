//
//  ExpandedPhotoViewModelTest.swift
//  Doggoh-StarterTests
//
//  Created by Anca Grigoriu on 08/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import XCTest
@testable import Doggoh_Starter

class ExpandedPhotoViewModelTest: XCTestCase {

    var sut: ExpanededPhotoViewModel!
    var expectedBreed: Breed!
    var expectedPhotoIndex: Int!
    
    override func setUp() {
        let breedExpectation = expectation(description: "Expecting to get a valid breed")
        
        BreedsRepository.getBreedList {[weak self] (result) in
            switch result {
            case .success(let fetchedRC):
                if let breeds = fetchedRC.fetchedObjects,
                    breeds.count > 0 {
                    let selectedBreed = breeds[0]
                    let selectedPhotoIndex = 0
                    
                    self?.expectedBreed = selectedBreed
                    self?.expectedPhotoIndex = selectedPhotoIndex
                    self?.sut = ExpanededPhotoViewModel(withBreed: selectedBreed, andCurrentIndex: selectedPhotoIndex)
                }
                else {
                    fatalError("Expected condittions have not been met")
                }
            case .failure(_):
                fatalError("Expected condittions have not been met")
            }
            breedExpectation.fulfill()
        }
        
        wait(for: [breedExpectation], timeout: 10)
    }

    func testConstructor() {
        XCTAssertEqual(sut.breed.specificBreedName, expectedBreed.specificBreedName)
        XCTAssertEqual(sut.currentPhotoIndex, expectedPhotoIndex)
    }
    
    func testNumberOfPhotos() {
        XCTAssertGreaterThan(sut.numberOfPhotos(), 0)
    }
    
    func testCellViewModel() {
        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertNotNil(sut.cellViewModel(atIndexPath: indexPath))
    }
}
