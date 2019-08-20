//
//  DogAPIClient.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

enum DogAPI {
    case allDogs
    case randomImage
    case image(breed: String)
    //    case image(breed: String, subbreed: String)
}

extension DogAPI {
    var endpoint: String {
        switch self {
        case .allDogs:
            return "breeds/list/all"
        case .randomImage:
            return "breeds/image/random"
        case .image(let breed):
            return "breed/\(breed)/images/random"
        }
    }
    
    //    var method: String {
    //        return "GET"
    //    }
}

class DogAPIClient {
    let baseURL: URL
    
    static let sharedInstance = DogAPIClient(baseURL: URL(string: "https://dog.ceo/api/")!)
    
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func getAllDogs(_ completion: @escaping (Result<[DogResponse], NetworkError>) -> Void) {
        let url = URL(string: "\(baseURL)\(DogAPI.allDogs.endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    var dogs: [DogResponse] = []
                    let allDogs = try JSONDecoder().decode(AllDogsResponse.self, from: data)
                    allDogs.message.forEach({
                        dogs.append(DogResponse(breed: $0.key, subbreeds: $0.value))
                    })
                    completion(.success(dogs))
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    
    func getRandomImage(_ completion: @escaping (Result<DogImageResponse, NetworkError>) -> Void) {
        let url =  URL(string: "\(baseURL)\(DogAPI.randomImage.endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
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
    
    func getRandomImage(withBreed breed: String, completion: @escaping (Result<DogImageResponse, NetworkError>) -> Void) {
        let url =  URL(string: "\(baseURL)\(DogAPI.image(breed: breed).endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
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
