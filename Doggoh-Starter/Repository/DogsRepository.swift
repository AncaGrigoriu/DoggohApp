//
//  DogsRepository.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 30/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct DogsRepository {
    private static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private static var fetchRC: NSFetchedResultsController<Dog>!
    
    static func getDogs() -> [Dog]? {
        getDogsFromDB()
        
        if let objects = fetchRC.fetchedObjects,
            objects.count == 0 {
            getDogsFromJSON()
        }
        
        return fetchRC.fetchedObjects
    }
    
    private static func getDogsFromJSON() {
        print("Getting dogs from JSON")
        guard let URL = Bundle.main.url(forResource: "Dogs", withExtension: "plist"),
            let photosFromPlist = NSArray(contentsOf: URL) as? [[String:String]] else {
                return
        }
        for dictionary in photosFromPlist {
            if let name = dictionary["Name"], let photo = dictionary["Photo"],
                let image = UIImage(named: photo) {
                addDogToDB(name: name, photo: image.pngData() as NSData?)
            }
        }
        getDogsFromDB()
    }
    
    private static func getDogsFromDB() {
        print("Got dogs from DB")
        let request = Dog.fetchRequest() as NSFetchRequest<Dog>
        request.sortDescriptors = []
        
        do {
            fetchRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private static func addDogToDB(name: String, photo: NSData?) {
        let dog = Dog(entity: Dog.entity(), insertInto: context)
        dog.image = photo
        dog.name = name
        appDelegate.saveContext()
    }
}
