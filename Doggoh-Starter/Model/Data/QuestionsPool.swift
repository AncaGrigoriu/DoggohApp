//
//  QuestionPool.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct QuestionsPool {
    var pool: [QuestionClass]
    
    init(rawData: Dictionary<String, AnyObject>) {
        pool = [QuestionClass]()
        
        if let jsonData = rawData["questions"] as? [[String:AnyObject]] {
            jsonData.forEach { item in
                if let questionText = item["question"] as? String,
                    let optionsArray = item["options"] as? [String],
                    let answer = item["answer"] as? String {
                    pool.append(QuestionClass(question: questionText, options: optionsArray, answer: answer))
                }
            }
        }
    }
    
    func getQuestions() -> [QuestionClass] {
        guard pool.count >= 10 else {
            return pool
        }
        
        var poolCopy = pool
        var result = [QuestionClass]()
        while result.count < 10 {
            let randomIndex = Int.random(in: 0..<poolCopy.count)
            result.append(poolCopy[randomIndex])
            poolCopy.remove(at: randomIndex)
        }
        return result
    }
}
