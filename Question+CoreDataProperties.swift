//
//  Question+CoreDataProperties.swift
//  
//
//  Created by Anca Grigoriu on 29/08/2019.
//
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    @NSManaged public var answer: String
    @NSManaged public var options: [String]
    @NSManaged public var question: String

}
