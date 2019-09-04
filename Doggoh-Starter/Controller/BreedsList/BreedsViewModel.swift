//
//  BreedsViewModel.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import CoreData

class BreedsViewModel {
    var breedsFetchRC: NSFetchedResultsController<Breed>!
    var dataLoaded: (() -> Void)? {
        didSet {
            if breedsFetchRC != nil {
                dataLoaded?()
            } else {
                getData()
            }
        }
    }
    var imageLoaded: ((IndexPath) -> Void)?
    
    func getData() {
        BreedsRepository.getBreedList { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let breeds):
                    self.breedsFetchRC = breeds
                    self.dataLoaded?()
                }
            }
        }
    }
    
    func numberOfBreeds() -> Int {
        return breedsFetchRC?.sections?.count ?? 0
    }
    
    func numberOfSubBreeds(forSection section: Int) -> Int {
        guard let sections = breedsFetchRC?.sections,
            let subbreeds = sections[section].objects else { return 0 }
        return subbreeds.count
    }
    
    func isSingleBreed(atIndexPath indexPath: IndexPath) -> Bool {
        let breed = breedsFetchRC.object(at: indexPath)
        return breed.generalBreedName.lowercased() == breed.specificBreedName.lowercased()
    }
    
    func breedViewModel(atIndexPath indexPath: IndexPath) -> BreedTableViewCellViewModel {
        let breed = breedsFetchRC.object(at: indexPath)
        checkBreedImageExists(atIndexPath: indexPath)
        return BreedTableViewCellViewModel(withBreed: breed)
    }
    
    func subBreedViewModel(atIndexPath indexPath: IndexPath) -> SubBreedTableViewCellViewModel {
        let breed = breedsFetchRC.object(at: indexPath)
        checkBreedImageExists(atIndexPath: indexPath)
        return SubBreedTableViewCellViewModel(withBreed: breed)
    }
    
    func headerViewModel(forSection section: Int) -> DogsTableViewHeaderViewModel {
        guard let sections = breedsFetchRC?.sections,
            let subbreeds = sections[section].objects as? [Breed] else {
                return DogsTableViewHeaderViewModel(breedNameString: "")
        }
        
        let breed = subbreeds[0].generalBreedName
        return DogsTableViewHeaderViewModel(breedNameString: breed)
    }
    
    func update(cell: CellConfigurable, atIndexPath indexPath: IndexPath) {
        let breed = breedAt(indexPath: indexPath)
        if let data = breed.photo as Data? {
            cell.configImage(with: data)
        }
    }
    
    func shouldHeaderBeVisible(forSection section: Int) -> Bool {
        guard let sections = breedsFetchRC?.sections,
            let subbreeds = sections[section].objects as? [Breed] else { return false }
        
        let breed = subbreeds[0].generalBreedName
        
        if subbreeds.count > 1 || subbreeds[0].specificBreedName != breed {
            return true
        }

        return false
    }
    
    func isLastSection(currentSection: Int) -> Bool {
        if let sections = breedsFetchRC?.sections,
            currentSection == sections.count - 1 {
            return true
        }
        
        return false
    }
    
    func breedAt(indexPath: IndexPath) -> Breed {
        return breedsFetchRC.object(at: indexPath)
    }
    
    private func checkBreedImageExists(atIndexPath indexPath: IndexPath) {
        guard let breed = breedsFetchRC?.object(at: indexPath), breed.photo != nil else {
            getBreedImage(forIndexPath: indexPath)
            return
        }
    }
    
    private func getBreedImage(forIndexPath indexPath: IndexPath) {
        let breed = breedsFetchRC!.object(at: indexPath)
        let generalBreed = breed.generalBreedName
        
        DogImagesRepository.getRandomImage(forBreed: generalBreed.lowercased()) { result in
            switch result {
            case .success(let imageUrl):
                DispatchQueue.global().async {
                    do {
                        let data = try Data(contentsOf: URL(string: imageUrl)!)
                        DispatchQueue.main.async {
                            breed.photo = data as NSData
                            BreedsRepository.updateBreed(at: indexPath, with: breed)
                            self.imageLoaded?(indexPath)
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
}
