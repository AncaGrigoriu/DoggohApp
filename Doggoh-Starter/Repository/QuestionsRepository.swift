//
//  QuestionsRepository.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct QuestionsRepository {
    static let filename = "dog_questions_multiple"
    
    static func dataFromJSON(withName name: String) -> Dictionary<String, AnyObject>? {
        
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
        } catch let error{
            print("Error loading file: \(error)")
            return nil
        }
        
        return nil
    }
}
