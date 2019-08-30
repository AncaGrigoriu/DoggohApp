//
//  DogImagesRepository.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct DogImagesRepository {
//    static let apiClient = DogAPIClient.sharedInstance
    static let apiClient = DoggohAPIClient.sharedInstance
    static let imaggaAPIClient = ImaggaAPIClient.sharedInstance
    
    private static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private static var fetchRC: NSFetchedResultsController<BreedImage>!
    
    static func getRandomImage(_ completion: @escaping (Result<(String), NetworkError>) -> Void) {
        apiClient.getRandomImage { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let image):
                completion(.success(image.imageURL))
            }
        }
    }
    
    static func getImages(for breed: Breed, withCount count: Int, _ completion: @escaping (Result<(NSFetchedResultsController<BreedImage>?), NetworkError>) -> Void) {
        print("Getting images from network")
        getRandomImages(for: breed, withCount: count, completion)
    }
    
    static func getStoredImages(for breed: Breed) -> NSFetchedResultsController<BreedImage>? {
        let request = BreedImage.fetchRequest() as NSFetchRequest<BreedImage>
        request.predicate = NSPredicate(format: "breed == %@", breed)
        request.sortDescriptors = []
        do {
            fetchRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        return fetchRC
    }
    
    static func getRandomImage(forBreed: String, _ completion: @escaping (Result<(String), NetworkError>) -> Void) {
        apiClient.getRandomImage(withBreed: forBreed) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let image):
                completion(.success(image.imageURL))
            }
        }
    }
    
    private static func getRandomImages(for breed: Breed, withCount count: Int, _ completion: @escaping (Result<(NSFetchedResultsController<BreedImage>?), NetworkError>) -> Void) {
        let breedName = breed.generalBreedName.lowercased()
        let subBreedName = breed.specificBreedName.lowercased()
        let isSingularBreed = (breed.specificBreedName.lowercased() == breed.generalBreedName.lowercased())
        
        let networkCompletion: (Result<([String]), NetworkError>) -> Void = { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("error: \(error)")
                    completion(.failure(error))
                case .success(let values):
                    do {
                        for itemURL in values {
                            let data = try Data(contentsOf: URL(string: itemURL)!)
                            addPhoto(for: breed, data: data)
                        }
                        completion(.success(fetchRC))
                    } catch let error {
                        print("error: \(error)")
                        completion(.failure(.decodingError))
                    }
                }
            }
        }
        
        if isSingularBreed {
            getRandomImages(forBreed: breedName, withCount: count, networkCompletion)
        } else {
            getRandomImages(forBreed: breedName, forSubBreed: subBreedName, withCount: count, networkCompletion)
        }
    }
    
    private static func addPhoto(for breed: Breed, data: Data) {
        let breedImage = BreedImage(entity: BreedImage.entity(), insertInto: context)
        breedImage.breedName = breed.specificBreedName
        breedImage.image = data as NSData
        breedImage.breed = breed
        breed.addToBreedPhotos(breedImage)
        appDelegate.saveContext()
    }
    
    private static func getRandomImages(forBreed: String, withCount count: Int, _ completion: @escaping (Result<([String]), NetworkError>) -> Void) {
        apiClient.getRandomImages(withBreed: forBreed, withCount: count) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let images):
                    completion(.success(images.imageURLs))
                }
            }
        }
    }
    
    private static func getRandomImages(forBreed: String, forSubBreed: String, withCount count: Int, _ completion: @escaping (Result<([String]), NetworkError>) -> Void) {
        apiClient.getRandomImages(withBreed: forBreed, withSubBreed: forSubBreed, withCount: count) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let images):
                    completion(.success(images.imageURLs))
                }
            }
        }
    }
    
    static func checkBreedMatch(with image: Data, _ completion: @escaping (Result<([String]), NetworkError>) -> Void) {
        imaggaAPIClient.postTags(with: image) { response in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let result):
                var tags = [String]()
                result.forEach{ tag in
                    tags.append(tag.tag.en)
                }
                completion(.success(tags))
            }
        }
    }
}
