//
//  BreedImage+CoreDataProperties.swift
//  
//
//  Created by Anca Grigoriu on 30/08/2019.
//
//

import Foundation
import CoreData


extension BreedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BreedImage> {
        return NSFetchRequest<BreedImage>(entityName: "BreedImage")
    }

    @NSManaged public var image: NSData
    @NSManaged public var breedName: String
    @NSManaged public var breed: Breed

}
