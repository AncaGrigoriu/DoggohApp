//
//  ImaggaAPIClient.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 20/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import Alamofire

enum ImaggaAPI {
    case getTags
    case postTags
}

extension ImaggaAPI {
    var url: String {
        switch self {
        case .getTags:
            return "tags"
        case .postTags:
            return "tags"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getTags:
            return .get
        case .postTags:
            return .post
        }
    }
}

class ImaggaAPIClient {
    static let sharedInstance = ImaggaAPIClient(baseURL: "https://api.imagga.com/v2/")
    
    let baseURL: String
    
    let headers: HTTPHeaders = ["Authorization": AuthParameter.basicAuth]
    
    private init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    private struct AuthParameter {
        static let basicAuth = "Basic YWNjXzQ2NDczMzBlYjM2MDkyMjo0Nzc5MGUzNjY2OGRhMzJiZjMwNTY1MjM3YWZlODI3ZQ=="
    }
    
    private struct Parameter {
        static let imageUrl = "image_url"
        static let image = "image"
    }
    
    func getTags(for imageURL: String) {
        let parameters = [Parameter.imageUrl : imageURL]
        
        request(endpoint: ImaggaAPI.getTags, parameters: parameters).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let value):
                if let data = response.data {
                    do {
                        print(value)
                        let responseObject = try JSONDecoder().decode(TagsResponse.self, from: data)
                        print(responseObject)
                    }
                    catch let error {
                        print(error)
                    }
                }
            }
        }
    }
    
    func postTags(with image: Data, _ completion: @escaping (Result<([Tag]), NetworkError>) -> Void) {
        let url = "\(baseURL)\(ImaggaAPI.postTags.url)"
        AF.upload(multipartFormData: { (multipartFromData) in
            multipartFromData.append(image, withName: Parameter.image, mimeType: "image/jpg")
        }, to: url, headers: headers).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                completion(.failure(.domainError))
            case .success(_):
                if let data = response.data {
                    do {
                        let responseObject = try JSONDecoder().decode(TagsResponse.self, from: data)
                        completion(.success(responseObject.result.tags))
                    } catch let error {
                        print(error)
                        completion(.failure(.decodingError))
                    }
                }
            }
        }
    }
    
    private func request(endpoint: ImaggaAPI,
                         parameters: Parameters? = nil
        ) -> DataRequest {
        let url = "\(baseURL)\(endpoint.url)"
        return AF.request(url, method: endpoint.method, parameters: parameters, headers: headers)
    }
}

