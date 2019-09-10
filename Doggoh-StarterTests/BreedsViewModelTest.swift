//
//  BreedsViewModelTest.swift
//  Doggoh-StarterTests
//
//  Created by Anca Grigoriu on 08/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import XCTest
@testable import Doggoh_Starter

class BreedsViewModelTest: XCTestCase {
    
    func testGetData() {
        let sut = BreedsViewModel()
        
        let dataExpectation = expectation(description: "Expecting breeds list")
        sut.dataLoaded = {
            dataExpectation.fulfill()
        }
        
        wait(for: [dataExpectation], timeout: 30)
        
        XCTAssertNotNil(sut.breedsFetchRC)
    }

    func testNumberOfBreeds() {
        let sut = BreedsViewModel()
        
        XCTAssertEqual(sut.numberOfBreeds(), 0)
        
        let dataExpectation = expectation(description: "Expecting breeds list")
        sut.dataLoaded = {
            dataExpectation.fulfill()
        }
        
        wait(for: [dataExpectation], timeout: 30)
        
        XCTAssertGreaterThan(sut.numberOfBreeds(), 0)
    }
    
    func testNumberOfSubBreeds() {
        let sut = BreedsViewModel()
        
        XCTAssertEqual(sut.numberOfSubBreeds(forSection: 0), 0)
        
        let dataExpectation = expectation(description: "Expecting breeds list")
        sut.dataLoaded = {
            dataExpectation.fulfill()
        }
        
        wait(for: [dataExpectation], timeout: 30)
        
        XCTAssertGreaterThan(sut.numberOfSubBreeds(forSection: 0), 0)
    }
    
    func testIsSingleBreed() {
        let sut = BreedsViewModel()
    
        let dataExpectation = expectation(description: "Expecting breeds list")
        sut.dataLoaded = {
            dataExpectation.fulfill()
        }
        
        wait(for: [dataExpectation], timeout: 30)
        
        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertTrue(sut.isSingleBreed(atIndexPath: indexPath))
    }
    
    func testIsSingleBreed_falseResult() {
        let sut = BreedsViewModel()
        
        let dataExpectation = expectation(description: "Expecting breeds list")
        sut.dataLoaded = {
            dataExpectation.fulfill()
        }
        
        wait(for: [dataExpectation], timeout: 30)
        
        let indexPath = IndexPath(row: 0, section: 14)
        XCTAssertFalse(sut.isSingleBreed(atIndexPath: indexPath))
    }
    
    func testBreedViewModel() {
        let sut = BreedsViewModel()
        
        let dataExpectation = expectation(description: "Expecting breeds list")
        sut.dataLoaded = {
            dataExpectation.fulfill()
        }
        
        wait(for: [dataExpectation], timeout: 30)
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        XCTAssertNotNil(sut.breedViewModel(atIndexPath: indexPath))
    }
    
    func testSubBreedViewModel() {
        let sut = BreedsViewModel()
        
        let dataExpectation = expectation(description: "Expecting breeds list")
        sut.dataLoaded = {
            dataExpectation.fulfill()
        }
        
        wait(for: [dataExpectation], timeout: 30)
        let indexPath = IndexPath(row: 0, section: 14)
        
        XCTAssertNotNil(sut.subBreedViewModel(atIndexPath: indexPath))
    }
    
    func testHeaderViewModel() {
        let sut = BreedsViewModel()
        
        XCTAssertNotNil(sut.headerViewModel(forSection: 0))
        
        let dataExpectation = expectation(description: "Expecting breeds list")
        sut.dataLoaded = {
            dataExpectation.fulfill()
        }
        
        wait(for: [dataExpectation], timeout: 30)
        
        XCTAssertNotNil(sut.headerViewModel(forSection: 0))
        XCTAssertNotNil(sut.headerViewModel(forSection: 14))
    }
    
    func testShouldHeaderBeVisible() {
        let sut = BreedsViewModel()
        
        let dataExpectation = expectation(description: "Expecting breeds list")
        sut.dataLoaded = {
            dataExpectation.fulfill()
        }
        
        wait(for: [dataExpectation], timeout: 30)
        
        XCTAssertTrue(sut.shouldHeaderBeVisible(forSection: 14))
        XCTAssertFalse(sut.shouldHeaderBeVisible(forSection: 0))
    }

    func testIsLastSection() {
        let sut = BreedsViewModel()
        
        XCTAssertFalse(sut.isLastSection(currentSection: 0))
        
        let dataExpectation = expectation(description: "Expecting breeds list")
        sut.dataLoaded = {
            dataExpectation.fulfill()
        }
        
        wait(for: [dataExpectation], timeout: 30)
        
        
        XCTAssertFalse(sut.isLastSection(currentSection: 0))
        let lastSection = sut.breedsFetchRC.sections!.count - 1
        XCTAssertTrue(sut.isLastSection(currentSection: lastSection))
    }
    
    func testBreedAt() {
        let sut = BreedsViewModel()
        
        let dataExpectation = expectation(description: "Expecting breeds list")
        sut.dataLoaded = {
            dataExpectation.fulfill()
        }
        
        wait(for: [dataExpectation], timeout: 30)
        let indexPath = IndexPath(row: 0, section: 0)
        let expectedBreed = sut.breedsFetchRC.object(at: indexPath)
        XCTAssertEqual(sut.breedAt(indexPath: indexPath).specificBreedName, expectedBreed.specificBreedName)
    }
    
    
}
