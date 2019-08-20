//
//  NetworkManager.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case domainError
    case decodingError
}

class NetworkManager {
    
    let session = URLSession.shared
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func getJSON(_ completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    completion(.failure(.domainError))
                }
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
    }
}
