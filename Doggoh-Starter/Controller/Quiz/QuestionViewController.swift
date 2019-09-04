//
//  QuestionViewController.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 03/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

protocol QuestionDelegate: class {
    func didSubmitAnswer(correct: Bool)
}

class QuestionViewController: UIViewController {
    
    var clickedButton: QuizButton?
    weak var delegate: QuestionDelegate?
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var submitButton: QuizButton!
    
    @IBOutlet weak var optionAButton: QuizButton!
    @IBOutlet weak var optionBButton: QuizButton!
    @IBOutlet weak var optionCButton: QuizButton!
    @IBOutlet weak var optionDButton: QuizButton!
    
    var viewmodel: QuestionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        setupLabels()
        setUpButtons()
    }
    
    private func setupLabels() {
        questionLabel.text = viewmodel.questionString
        counterLabel.text = viewmodel.counterString
    }
    
    func setUpButtons() {
        initOptionsButtons()
        initSubmitButton()
    }
    
    func initOptionsButtons() {
        optionAButton.configure(withType: .multipleOptions, withTitle: viewmodel.optionA)
        optionBButton.configure(withType: .multipleOptions, withTitle: viewmodel.optionB)
        optionCButton.configure(withType: .multipleOptions, withTitle: viewmodel.optionC)
        optionDButton.configure(withType: .multipleOptions, withTitle: viewmodel.optionD)
    }
    
    func initSubmitButton() {
        submitButton.configure(withType: .action, withTitle: viewmodel.submitButtonString)
        submitButton.isEnabled = false
        submitButton.update(forState: .disabled)
    }
    
    func evaluate() -> Bool {
        var selectedAnswer: String = ""
        
        switch clickedButton {
        case optionAButton:
            selectedAnswer = "a"
        case optionBButton:
            selectedAnswer = "b"
        case optionCButton:
            selectedAnswer = "c"
        case optionDButton:
            selectedAnswer = "d"
        default:
            break
        }
        
        return viewmodel.isCorrectAnswer(selectedAnswer)
    }
    
    @IBAction func optionButtonClicked(_ sender: QuizButton) {
        submitButton.isEnabled = true
        submitButton.update(forState: .normal)
        
        if let previousSelectedItem = clickedButton {
            previousSelectedItem.isHighlighted = false
            previousSelectedItem.update(forState: .normal)
        }
        
        clickedButton = sender
        sender.isHighlighted = true
        sender.update(forState: .highlighted)
    }
    
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        delegate?.didSubmitAnswer(correct: evaluate())
    }
}
