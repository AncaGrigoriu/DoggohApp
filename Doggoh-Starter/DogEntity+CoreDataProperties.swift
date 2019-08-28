//
//  DogEntity+CoreDataProperties.swift
//  
//
//  Created by Anca Grigoriu on 27/08/2019.
//
//

import Foundation
import CoreData


extension DogEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DogEntity> {
        return NSFetchRequest<DogEntity>(entityName: "DogEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: NSData?

}
