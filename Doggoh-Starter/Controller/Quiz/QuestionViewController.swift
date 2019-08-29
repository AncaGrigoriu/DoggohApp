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

    var question: QuestionClass!
    var index: Int!
    var total: Int!
    
    var clickedButton: QuizButton?
    weak var delegate: QuestionDelegate?
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var submitButton: QuizButton!
    
    @IBOutlet weak var optionAButton: QuizButton!
    @IBOutlet weak var optionBButton: QuizButton!
    @IBOutlet weak var optionCButton: QuizButton!
    @IBOutlet weak var optionDButton: QuizButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        setUpButtons()
        update(withQuestion: question, atIndex: index, inTotal: total)
    }
    
    private func update(withQuestion question: QuestionClass, atIndex index: Int, inTotal total: Int) {
        questionLabel.text = question.question
        counterLabel.text = "\(index + 1)/\(total)"
    }
    
    func setUpButtons() {
        initOptionsButtons()
        initSubmitButton()
    }
    
    func initOptionsButtons() {
        optionAButton.configure(withType: .multipleOptions, withTitle: question.options[0])
        optionBButton.configure(withType: .multipleOptions, withTitle: question.options[1])
        optionCButton.configure(withType: .multipleOptions, withTitle: question.options[2])
        optionDButton.configure(withType: .multipleOptions, withTitle: question.options[3])
    }
    
    func initSubmitButton() {
        submitButton.isEnabled = false
        
        if index == total - 1 {
            submitButton.configure(withType: .action, withTitle: "FINISH")
        } else {
            submitButton.configure(withType: .action, withTitle: "NEXT")
        }
        
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
        
        return selectedAnswer == question.answer
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
