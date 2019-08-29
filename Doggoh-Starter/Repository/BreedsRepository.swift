//
//  DogsRepository.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct BreedsRepository {
    static let filename = "alldogsresponse"
    static let apiClient = DoggohAPIClient.sharedInstance
    
    private static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private static var fetchRC: NSFetchedResultsController<Breed>!
    
    static func dataFromJSON(withName name: String) -> Dictionary<String, AnyObject>? {
        
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            print("No json file found at path: \(name).json")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>{
                return jsonResult
            }
        } catch let error{
            print("Error loading file: \(error)")
            return nil
        }
        
        return nil
    }
    
    static func updateBreed(at indexPath: IndexPath, with breed: Breed) {
        let updatedBreed = fetchRC.object(at: indexPath)
        updatedBreed.generalBreedName = breed.generalBreedName
        updatedBreed.photo = breed.photo
        updatedBreed.specificBreedName = breed.specificBreedName
        appDelegate.saveContext()
    }
    
    static func getBreedList(_ completion: @escaping (Result<NSFetchedResultsController<Breed>, NetworkError>) -> Void) {
        getStoredDogs()
        
        if let breeds = fetchRC.fetchedObjects,
            breeds.count > 0 {
            print("Got stored dogs")
            completion(.success(fetchRC))
        } else {
            print("Getting dogs from network")
            getDogs(completion)
        }
    }
    
    private static func getDogs(_ completion: @escaping (Result<NSFetchedResultsController<Breed>, NetworkError>) -> Void) {
        apiClient.getAllDogs { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let dogsResponse):
                dogsResponse.forEach{ dogResponse in
                    getBreeds(dogResponse: dogResponse)
                }
                getStoredDogs()
                completion(.success(fetchRC))
            }
        }
    }
    
    private static func getBreeds(dogResponse: DogResponse) {
        let generalBreed = dogResponse.breed
        
        dogResponse.subbreeds.forEach { breedName in
            addBreedToDB(generalBreedName: generalBreed.uppercased(), specificBreedName: breedName.capitalized, photo: nil)
        }

        if dogResponse.subbreeds.count == 0 {
            addBreedToDB(generalBreedName: generalBreed.uppercased(), specificBreedName: generalBreed.uppercased(), photo: nil)
        }
    }
    
    private static func getStoredDogs() {
        let request = Breed.fetchRequest() as NSFetchRequest<Breed>
        let sort = NSSortDescriptor(key: #keyPath(Breed.generalBreedName), ascending: true, selector: nil)
        request.sortDescriptors = [sort]
        do {
            fetchRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(Breed.generalBreedName), cacheName: nil)
            try fetchRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    private static func addBreedToDB(generalBreedName: String, specificBreedName: String, photo: NSData?) {
        let newBreed = Breed(entity: Breed.entity(), insertInto: context)
        newBreed.generalBreedName = generalBreedName
        newBreed.photo = photo
        newBreed.specificBreedName = specificBreedName
        newBreed.subBreedPhotos = []
        appDelegate.saveContext()
    }
}
