//
//  MultipleDogImagesResponse.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 20/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct MultipleDogImagesResponse: Codable {
    let status: String
    let imageURLs: [String]
    
    enum CodingKeys: String, CodingKey {
        case imageURLs = "message"
        case status = "status"
    }
}
