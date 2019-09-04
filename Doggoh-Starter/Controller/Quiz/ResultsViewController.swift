//
//  ResultsViewController.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 04/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

protocol ResultsDelegate: class {
    func willRetakeQuiz()
}

class ResultsViewController: UIViewController {

    weak var delegate: ResultsDelegate?
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var retakeQuizButton: QuizButton!
    
    var viewmodel: ResultsViewModel! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
        configureLabels()
        configureButton()
    }
    
    func configureLabels() {
        scoreLabel.text = viewmodel.scoreString
        totalScoreLabel.text = viewmodel.totalScoreString
    }
    
    func configureButton() {
        retakeQuizButton.configure(withType: .action, withTitle: "RETAKE QUIZ")
    }

    @IBAction func restartQuizClicked(_ sender: UIButton) {
        delegate?.willRetakeQuiz()
    }
}

