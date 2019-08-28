//
//  QuestionEntity+CoreDataProperties.swift
//  
//
//  Created by Anca Grigoriu on 27/08/2019.
//
//

import Foundation
import CoreData


extension QuestionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionEntity> {
        return NSFetchRequest<QuestionEntity>(entityName: "QuestionEntity")
    }

    @NSManaged public var question: String?
    @NSManaged public var answer: String?
    @NSManaged public var options: NSObject?

}
