//
//  QuestionsRepository.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct QuestionsRepository {
    static let filename = "dog_questions_multiple"
    
    private static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private static var fetchRC: NSFetchedResultsController<Question>!
    
    private static func dataFromJSON(withName name: String) -> Dictionary<String, AnyObject>? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            print("No json file found at path: \(name).json")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>{
                return jsonResult
            }
        } catch let error {
            print("Error loading file: \(error)")
            return nil
        }
        
        return nil
    }
    
    private static func getQuestionsFromDB() {
        let request = Question.fetchRequest() as NSFetchRequest<Question>
        request.sortDescriptors = []
        do {
            fetchRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private static func getQuestionsFromJSON() {
        let data = dataFromJSON(withName: filename)
        
        if let rawData = data {
            if let jsonData = rawData["questions"] as? [[String:AnyObject]] {
                jsonData.forEach { item in
                    if let questionText = item["question"] as? String,
                        let optionsArray = item["options"] as? [String],
                        let answer = item["answer"] as? String {
                        addQuestion(questionContent: questionText, options: optionsArray, answer: answer)
                    }
                }
            }
        }
        
        getQuestionsFromDB()
    }
    
    private static func addQuestion(questionContent: String, options: [String], answer: String) {
        let question = Question(entity: Question.entity(), insertInto: context)
        question.answer = answer
        question.options = options
        question.question = questionContent
        appDelegate.saveContext()
    }
    
    static func getQuestions() -> [Question] {
        getQuestionsFromDB()
        
        if let questions = fetchRC.fetchedObjects,
            questions.count == 0 {
            getQuestionsFromJSON()
        }
        
        if let questions = fetchRC.fetchedObjects,
            questions.count <= 10 {
            return questions
        }
        
        var questions: [Question] = []
        let range = 0..<(fetchRC.fetchedObjects?.count ?? 0)
        
        while questions.count < 10 {
            let index = Int.random(in: range)
            let indexPath = IndexPath(item: index, section: 0)
            let question = fetchRC.object(at: indexPath)
            
            if !questions.contains(question) {
                questions.append(question)
            }
        }
        
        return questions
    }
}
