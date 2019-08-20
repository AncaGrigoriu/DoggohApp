//
//  DogImagesRepository.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct DogImagesRepository {
    static let apiClient = DogAPIClient.sharedInstance
    
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
}
