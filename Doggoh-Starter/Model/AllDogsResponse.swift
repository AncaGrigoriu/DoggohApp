//
//  AllDogsResponse.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

typealias BreedName = String
typealias SubBreedName = String

struct AllDogsResponse: Codable {
    let message: [BreedName: [SubBreedName]]
}
