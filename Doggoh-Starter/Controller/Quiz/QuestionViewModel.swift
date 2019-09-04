//
//  QuestionViewModel.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct QuestionViewModel {
    let questionString: String
    let counterString: String
    let submitButtonString: String
    let optionA: String
    let optionB: String
    let optionC: String
    let optionD: String
    let correctAnswer: String
    
    init(withQuestion question: Question, withIndex index: Int, withTotal total: Int) {
        questionString = question.question
        counterString = "\(index + 1)/\(total)"
        
        if index == total - 1 {
            submitButtonString = "FINISH"
        } else {
            submitButtonString = "NEXT"
        }
        
        optionA = question.options[0]
        optionB = question.options[1]
        optionC = question.options[2]
        optionD = question.options[3]
        
        correctAnswer = question.answer
    }
    
    func isCorrectAnswer(_ answer: String) -> Bool {
        return answer == correctAnswer
    }
}
