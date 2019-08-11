//
//  QuizViewController.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var beginQuizButton: QuizButton!
    var coordinator: QuizCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        beginQuizButton.configure(withType: .action, withTitle: "BEGIN QUIZ")
    }

    @IBAction func beginQuizClicked(_ sender: UIButton) {
        if let data = QuestionsRepository.dataFromJSON(withName: QuestionsRepository.filename) {
            let questionsPool = QuestionsPool(rawData: data)
            let randomQuestions = questionsPool.getQuestions()
            
            coordinator = QuizCoordinator(questions: randomQuestions)
            coordinator.flowDelegate = self
            coordinator.startQuiz()
        }
    }
}

extension QuizViewController: QuizFlowDelegate {
    func willStartQuiz(insideNavigationController: UINavigationController) {
        present(insideNavigationController, animated: true, completion: nil)
    }

    func didFinishQuiz(withResultScreen screen: ResultsViewController) {
        navigationController?.popViewController(animated: false)
        navigationController?.pushViewController(screen, animated: false)
        dismiss(animated: true, completion: nil)
    }
    
    func willRetakeQuiz() {
        if let data = QuestionsRepository.dataFromJSON(withName: QuestionsRepository.filename) {
            let questionsPool = QuestionsPool(rawData: data)
            let randomQuestions = questionsPool.getQuestions()
            
            coordinator.setQuestions(questions: randomQuestions)
            coordinator.startQuiz()
        }
    }
}

extension QuizViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard viewController is QuizViewController else {
            navigationController?.popToRootViewController(animated: false)
            return
        }
    }
}
