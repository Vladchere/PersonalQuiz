//
//  QuestionViewController.swift
//  PersonalQuiz
//
//  Created by Vladislav on 02.06.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitchers: [UISwitch]!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedSlider: UISlider!
    @IBOutlet var rangedLabels: [UILabel]!
    
    @IBOutlet var questionProgressView: UIProgressView!
    
    //MARK: - Private propeties
    private let questions = Question.getQuestions()
    private var questionsIndex = 0
    private var answersChoosen: [Answer] = []
    private var answers: [Answer] {
        questions[questionsIndex].answers
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    // MARK: - IB Actions
    @IBAction func singleButtonAnswerPressed(_ sender: UIButton) {
        guard let currentIndexButton = singleButtons.firstIndex(of: sender) else { return }
        let currentAnswer = answers[currentIndexButton]
        
        answersChoosen.append(currentAnswer)
        nextQuestion()
    }
    
    @IBAction func multipleButtonAnswerPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitchers, answers) {
            if multipleSwitch.isOn {
                answersChoosen.append(answer)
            }
        }
        nextQuestion()
    }
    
    @IBAction func rangedAnwserButtonPressed() {
        let index = lroundf(rangedSlider.value * Float(answers.count - 1))
        let currentAnswer = answers[index]
        
        answersChoosen.append(currentAnswer)
        nextQuestion()
    }
}

// MARK: - Private methods
extension QuestionViewController {
    
    private func updateUI () {
        // Hide everything
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        
        // Get current question
        let currentQuestion = questions[questionsIndex]
        
        // Set current question for question label
        questionLabel.text = currentQuestion.text
        
        // Calculate progress
        let totalProgress = Float(questionsIndex) / Float(questions.count)
        
        // Set progress for progress question view
        questionProgressView.setProgress(totalProgress, animated: true)
        
        // Set navigation title
        title = "Вопрос № \(questionsIndex + 1) из \(questions.count)"
        
        //
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    private func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single: showSingleStackView(with: answers)
        case .multiple: showMultipleStackView(with: answers)
        case .ranged: showRangeStackView(with: answers)
        }
    }
    
    /// Setup single stack view
    ///
    /// - Parameter answers: array with answers
    ///
    /// Description of method
    private func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden = false
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.text, for: .normal)
        }
    }
    
    private func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden = false
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.text
        }
    }
    
    private func showRangeStackView(with answers: [Answer]) {
        rangedStackView.isHidden = false
        
        rangedLabels.first?.text = answers.first?.text
        rangedLabels.last?.text = answers.last?.text
        
    }
    
}

// MARK: - Navigation
extension QuestionViewController {
    
    private func nextQuestion() {
        questionsIndex += 1
        
        if questionsIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "resultSegue", sender: nil)
        }
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultsViewController else { return }
        
        resultVC.response = answersChoosen
    }
    
}
