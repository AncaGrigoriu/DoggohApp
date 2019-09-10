//
//  BreedDetailsViewModelTest.swift
//  Doggoh-StarterTests
//
//  Created by Anca Grigoriu on 06/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import XCTest
@testable import Doggoh_Starter

class BreedDetailsViewModelTest: XCTestCase {

    var sut: BreedDetailsViewModel!
    var expectedBreed: Breed!
    var expectedIndexPath: IndexPath!
    
    override func setUp() {
        let breedExpectation = expectation(description: "Expecting to get a valid breed")
        
        BreedsRepository.getBreedList {[weak self] (result) in
            switch result {
            case .success(let fetchedRC):
                if let breeds = fetchedRC.fetchedObjects,
                    breeds.count > 0 {
                    let selectedBreed = breeds[0]
                    let selectedIndexPath = IndexPath(row: 4, section: 7)
                    
                    self?.expectedBreed = selectedBreed
                    self?.expectedIndexPath = selectedIndexPath
                    self?.sut = BreedDetailsViewModel(breed: selectedBreed,
                                                      atIndexPath: selectedIndexPath)
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
        let isSingularBreed = (expectedBreed.specificBreedName.lowercased() == expectedBreed.generalBreedName.lowercased())
        let subBreedNameValue = !isSingularBreed ? "\(expectedBreed.specificBreedName.uppercased()) " : ""
        let breedName = expectedBreed.generalBreedName.uppercased()
        let navigationBarTitleString = "\(subBreedNameValue)\(breedName)"
        XCTAssertEqual(sut.navigationBarTitleString, navigationBarTitleString)
        XCTAssertEqual(sut.photosCount, 4)
    }
    
    func testNumberOfImages() {
        let numberOfImagesExpectation = expectation(description: "Expecting to get photos for breed")
        sut.onImagesLoaded = {
            numberOfImagesExpectation.fulfill()
        }
        
        let numberOfImages = sut.numberOfImages()
        XCTAssertNotNil(sut.numberOfImages, "Number of images returns not nil value")
        
        if numberOfImages == 0 {
            wait(for: [numberOfImagesExpectation], timeout: 60)
            XCTAssertGreaterThan(sut.numberOfImages(), 0)
        } else {
            numberOfImagesExpectation.fulfill()
            wait(for: [numberOfImagesExpectation], timeout: 10)
            XCTAssertGreaterThan(sut.numberOfImages(), 0)
        }
    }
    
    func testCellViewModel() {
        if sut.numberOfImages() > 0 {
            let cellIndexPath = IndexPath(row: 0, section: 0)
            XCTAssertNotNil(sut.cellViewModel(atIndexPath: cellIndexPath), "View model for cell is nil")
        }
    }

    func testPerformanceExample() {
        self.measure {
            sut.methodThatTakesSomeTime()
        }
    }

}
