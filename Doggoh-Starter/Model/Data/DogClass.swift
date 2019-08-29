//
//  Dog.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

struct DogClass {
    var image: UIImage
    var name: String
    
    init(image: UIImage, name: String) {
        self.image = image
        self.name = name
    }
    
    init?(dictionary: [String: String]) {
        guard let name = dictionary["Name"], let photo = dictionary["Photo"],
            let image = UIImage(named: photo) else {
                return nil
        }
        
        self.init(image: image, name: name)
    }
    
    static func allDogs() -> [DogClass] {
        var dogs = [DogClass]()
        guard let URL = Bundle.main.url(forResource: "Dogs", withExtension: "plist"),
            let photosFromPlist = NSArray(contentsOf: URL) as? [[String:String]] else {
                return dogs
        }
        for dictionary in photosFromPlist {
            if let dog = DogClass(dictionary: dictionary) {
                dogs.append(dog)
            }
        }
        return dogs
    }
}

extension DogClass: Equatable {
    static func ==(lhs: DogClass, rhs:DogClass) -> Bool {
        return lhs.name == rhs.name && lhs.image == rhs.image
    }
}
