//
//  QuizCoordinator.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit

protocol QuizFlowDelegate: class {
    func willStartQuiz(insideNavigationController: UINavigationController)
    func didFinishQuiz(withResultScreen screen: ResultsViewController)
    func willRetakeQuiz()
}

class QuizCoordinator {
    private var questions: [QuestionClass]
    private var currentIndex: Int = 0
    private var score: Int = 0
    private var navigationController: UINavigationController? = nil
    
    weak var flowDelegate: QuizFlowDelegate?
    
    init(questions: [QuestionClass]) {
        self.questions = questions
    }
    
    func setQuestions(questions: [QuestionClass]) {
        self.questions = questions
    }
    
    func startQuiz() {
        if let firstQuestion = questions.first,
            let firstQuizVC = getQuizViewController(question: firstQuestion, atIndex: 0, inTotal: questions.count) {
            currentIndex = 0
            navigationController = UINavigationController(rootViewController: firstQuizVC)
            flowDelegate?.willStartQuiz(insideNavigationController: navigationController!)
        }
    }
    
    func getQuizViewController(question: QuestionClass, atIndex index: Int, inTotal total: Int) -> QuestionViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "QuestionViewController") as? QuestionViewController
        
        viewController?.question = question
        viewController?.index = index
        viewController?.total = total
        viewController?.delegate = self
        
        return viewController
    }
    
    func getResultsViewController(withScore score: Int, inTotal total: Int) -> ResultsViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController
        
        viewController?.score = score
        viewController?.total = total
        viewController?.delegate = self
        
        return viewController
    }
    
    func goForward() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            if let currentQuizVC = getQuizViewController(question: questions[currentIndex], atIndex: currentIndex, inTotal: questions.count) {
                navigationController?.pushViewController(currentQuizVC, animated: false)
            }
        } else {
            finishQuiz()
        }
    }
    
    func finishQuiz() {
        if let resultsViewController = getResultsViewController(withScore: score, inTotal: questions.count) {
            flowDelegate?.didFinishQuiz(withResultScreen: resultsViewController)
        }
    }
}

extension QuizCoordinator: QuestionDelegate {
    func didSubmitAnswer(correct: Bool) {
        score += correct ? 1 : 0
        goForward()
    }
}

extension QuizCoordinator: ResultsDelegate {
    func willRetakeQuiz() {
        flowDelegate?.willRetakeQuiz()
    }
}
