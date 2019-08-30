//
//  Breed+CoreDataProperties.swift
//  
//
//  Created by Anca Grigoriu on 30/08/2019.
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
    @NSManaged public var subBreedPhotos: [BreedImage]?
    @NSManaged public var breedPhotos: NSSet?

}

// MARK: Generated accessors for breedPhotos
extension Breed {

    @objc(addBreedPhotosObject:)
    @NSManaged public func addToBreedPhotos(_ value: BreedImage)

    @objc(removeBreedPhotosObject:)
    @NSManaged public func removeFromBreedPhotos(_ value: BreedImage)

    @objc(addBreedPhotos:)
    @NSManaged public func addToBreedPhotos(_ values: NSSet)

    @objc(removeBreedPhotos:)
    @NSManaged public func removeFromBreedPhotos(_ values: NSSet)

}
