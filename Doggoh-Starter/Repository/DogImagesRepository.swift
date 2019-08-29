//
//  DogImagesRepository.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit

struct DogImagesRepository {
//    static let apiClient = DogAPIClient.sharedInstance
    static let apiClient = DoggohAPIClient.sharedInstance
    static let imaggaAPIClient = ImaggaAPIClient.sharedInstance
    
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
    
    static func getRandomImages(forBreed: String, withCount count: Int, _ completion: @escaping (Result<([String]), NetworkError>) -> Void) {
        apiClient.getRandomImages(withBreed: forBreed, withCount: count) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let images):
                completion(.success(images.imageURLs))
            }
        }
    }
    
    static func getRandomImages(forBreed: String, forSubBreed: String, withCount count: Int, _ completion: @escaping (Result<([String]), NetworkError>) -> Void) {
        apiClient.getRandomImages(withBreed: forBreed, withSubBreed: forSubBreed, withCount: count) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let images):
                completion(.success(images.imageURLs))
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
