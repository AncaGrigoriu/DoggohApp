//
//  DoggohAPIClient.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 20/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import Alamofire

enum DoggohAPI {
    case allDogs
    case randomImage
    case image(breed: String)
    case images(breed: String, count: Int)
}

extension DoggohAPI {
    var endpoint: String {
        switch self {
        case .allDogs:
            return "breeds/list/all"
        case .randomImage:
            return "breeds/image/random"
        case .image(let breed):
            return "breed/\(breed)/images/random"
        case .images(let breed, let count):
            return "breed/\(breed)/images/random/\(count)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .allDogs:
            return .get
        case .randomImage:
            return .get
        case .image(_):
            return .get
        case .images(_, _):
            return .get
        }
    }
}

class DoggohAPIClient {
    static let sharedInstance = DoggohAPIClient(url: "https://dog.ceo/api/")
    
    var baseURL: String
    
    private init(url: String) {
        baseURL = url
    }
    
    func getAllDogs(_ completion: @escaping (Result<[DogResponse], NetworkError>) -> Void) {
        let url = "\(baseURL)\(DoggohAPI.allDogs.endpoint)"
        
        AF.request(url, method: DoggohAPI.allDogs.method).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                completion(.failure(.domainError))
            case .success(_):
                if let data = response.data {
                    do {
                        var dogs: [DogResponse] = []
                        let allDogs = try JSONDecoder().decode(AllDogsResponse.self, from: data)
                        allDogs.message.forEach({
                            dogs.append(DogResponse(breed: $0.key, subbreeds: $0.value))
                        })
                        completion(.success(dogs))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                }
            }
        }
    }
    
    func getRandomImage(_ completion: @escaping (Result<DogImageResponse, NetworkError>) -> Void) {
        let url = "\(baseURL)\(DoggohAPI.randomImage.endpoint)"
        
        AF.request(url, method: DoggohAPI.randomImage.method).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                completion(.failure(.domainError))
            case .success(_):
                if let data = response.data {
                    do {
                        let image = try JSONDecoder().decode(DogImageResponse.self, from: data)
                        completion(.success(image))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                }
            }
        }
    }
    
    func getRandomImage(withBreed breed: String, completion: @escaping (Result<DogImageResponse, NetworkError>) -> Void) {
        let url = "\(baseURL)\(DoggohAPI.image(breed: breed).endpoint)"
        
        AF.request(url, method: DoggohAPI.image(breed: breed).method).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                completion(.failure(.domainError))
            case .success(_):
                if let data = response.data {
                    do {
                        let image = try JSONDecoder().decode(DogImageResponse.self, from: data)
                        completion(.success(image))
                    }
                    catch {
                        completion(.failure(.decodingError))
                    }
                }
            }
        }
    }
    
    func getRandomImages(withBreed breed: String, withCount count: Int, completion: @escaping (Result<MultipleDogImagesResponse, NetworkError>) -> Void) {
        let url = "\(baseURL)\(DoggohAPI.images(breed: breed, count: count).endpoint)"
        
        AF.request(url, method: DoggohAPI.images(breed: breed, count: count).method).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                completion(.failure(.domainError))
            case .success(_):
                if let data = response.data {
                    do {
                        let images = try JSONDecoder().decode(MultipleDogImagesResponse.self, from: data)
                        completion(.success(images))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                }
            }
        }
    }
}
