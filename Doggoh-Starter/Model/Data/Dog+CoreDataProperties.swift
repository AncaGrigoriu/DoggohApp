//
//  Dog+CoreDataProperties.swift
//  
//
//  Created by Anca Grigoriu on 29/08/2019.
//
//

import Foundation
import CoreData


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String?

}
