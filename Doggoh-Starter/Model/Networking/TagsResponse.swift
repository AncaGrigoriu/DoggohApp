//
//  TagsResponse.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 20/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct Language : Codable {
    let en: String
}

struct Tag : Codable {
    let tag : Language
    let confidence: Double
}

struct Tags : Codable {
    let tags: [Tag]
}

struct Status : Codable {
    let text: String
    let type: String
}

struct TagsResponse : Codable {
    let result: Tags
    let status: Status
}
