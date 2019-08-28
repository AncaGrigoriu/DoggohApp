//
//  BreedEntity+CoreDataProperties.swift
//  
//
//  Created by Anca Grigoriu on 27/08/2019.
//
//

import Foundation
import CoreData


extension BreedEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BreedEntity> {
        return NSFetchRequest<BreedEntity>(entityName: "BreedEntity")
    }

    @NSManaged public var generalBreedName: String?
    @NSManaged public var specificBreedName: String?
    @NSManaged public var photo: NSData?

}
