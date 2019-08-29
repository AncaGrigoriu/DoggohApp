//
//  Breed+CoreDataProperties.swift
//  
//
//  Created by Anca Grigoriu on 29/08/2019.
//
//

import Foundation
import CoreData


extension Breed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Breed> {
        return NSFetchRequest<Breed>(entityName: "Breed")
    }

    @NSManaged public var generalBreedName: String
    @NSManaged public var photo: NSData?
    @NSManaged public var specificBreedName: String
    @NSManaged public var subBreedPhotos: [BreedImage]

}
