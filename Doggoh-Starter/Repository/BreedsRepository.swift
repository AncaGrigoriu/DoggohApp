//
//  DogsRepository.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit

struct BreedsRepository {
    static let filename = "alldogsresponse"
    static let apiClient = DogAPIClient.sharedInstance
    
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
    
    static func getDogs(_ completion: @escaping (Result<([Breed]), NetworkError>) -> Void) {
        apiClient.getAllDogs { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let dogsResponse):
                var breeds = [Breed]()
                dogsResponse.forEach{ dogResponse in
                    breeds.append(contentsOf: getBreeds(dogResponse: dogResponse))
                }
                completion(.success(breeds))
            }
        }
    }
    
    private static func getBreeds(dogResponse: DogResponse) -> [Breed] {
        var breeds = [Breed]()
        let generalBreed = dogResponse.breed
        
        dogResponse.subbreeds.forEach { breedName in
            breeds.append(Breed(generalBreedName: generalBreed.uppercased(), specificBreedName: breedName.capitalized, photo: UIImage()))
        }
        
        if dogResponse.subbreeds.count == 0 {
            breeds.append(Breed(generalBreedName: generalBreed.uppercased(), specificBreedName: generalBreed.uppercased(), photo: UIImage()))
        }
        
        return breeds
    }
}
