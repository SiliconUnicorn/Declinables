//
//  SingleQuestionComparer.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 1/24/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit
import DeclinablesLibrary

final class SingleQuestionComparer: UIViewController{
    
    var totalQuestions = 5
    var currentQuestion = 1
    
    weak var presenter: Results? = nil
    
    @IBOutlet weak var pageDots: UIPageControl!
    
    var nounList = [AnswerChecker("Puella", "Puellae")]
    var formList =  [PossibleDeclensions.singularNominative]
    var answerList: [String?] = [nil]
    
    @IBOutlet weak var formField: UILabel!
    @IBOutlet weak var nounField: UILabel!
    
    @IBOutlet weak var correctAnswer: UILabel!
    @IBOutlet weak var userAnswer: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    fileprivate func setupController() {
        if presentingViewController != nil{
            if presentingViewController! is Results{
                presenter = (presentingViewController as! Results)
            }else if presentingViewController! is CustomWordNavigator{
                presenter = ((presentingViewController! as! CustomWordNavigator).viewControllers[(presentingViewController! as! CustomWordNavigator).viewControllers.count - 1]) as? Results
            } else {
                presenter = (parent! as! Results)
            }
            nounList = presenter!.resultsToGrade
            formList = presenter!.singleQuestionForms
            answerList = presenter!.singleQuestionAnswers
            
            totalQuestions = presenter!.totalQuestions
            
            //Tells Results that it shouldConsiderReview if 5 or more questions were practiced (normal conditions).
            if totalQuestions >= 5{
                presenter!.shouldConsiderReview = true
            }
        }else if parent is Results{
            presenter = (parent! as! Results)
            
            nounList = presenter!.resultsToGrade
            formList = presenter!.singleQuestionForms
            answerList = presenter!.singleQuestionAnswers
            
            totalQuestions = presenter!.totalQuestions
        }
        
        pageDots.numberOfPages = totalQuestions
        questionChanged()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupController()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupController()
        super.viewDidAppear(animated)
    }
    
    func questionChanged(){
        pageDots.currentPage = currentQuestion - 1
        
        if currentQuestion == totalQuestions{
            if parent == nil{
                nextButton.setTitle("Done ›", for: .normal)
            } else {
                nextButton.isEnabled = false
            }
        } else {
            nextButton.setTitle("Next ›", for: .normal)
            nextButton.isEnabled = true
        }
        if currentQuestion == 1{
            backButton.isEnabled = false
        } else {
            backButton.isEnabled = true
        }
        
        
        guard currentQuestion <= totalQuestions else{
            if parent == nil{
                nextButton.setTitle("Done ›", for: .normal)
            } else {
                nextButton.isEnabled = false
            }
            return
        }
        
        formField.text = formList[currentQuestion - 1].description
        nounField.text = "from " + nounList[currentQuestion - 1].correctRoot.0 + ", " + nounList[currentQuestion - 1].correctRoot.1
        if nounList[currentQuestion - 1].correctAnswers[formList[currentQuestion - 1].numericForm].lowercased() != answerList[currentQuestion - 1]?.lowercased(){
            correctAnswer.text = "Correct Answer: \"" + nounList[currentQuestion - 1].correctAnswers[formList[currentQuestion - 1].numericForm] + "\""
            correctAnswer.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            userAnswer.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else {
            correctAnswer.text = "Your Answer was Correct"
            correctAnswer.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            userAnswer.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        if answerList[currentQuestion - 1] != nil && answerList[currentQuestion - 1] != ""{
            userAnswer.text = "Your Answer: \"" + answerList[currentQuestion - 1]! + "\""
        } else {
            userAnswer.text = "You Did Not Answer"
        }
    }
    
    @IBAction func previousQuestion(_ sender: UIButton) {
        currentQuestion -= 1
        questionChanged()
    }
    
    @IBAction func nextQuestion(_ sender: UIButton) {
        if currentQuestion + 1 <= totalQuestions{
            currentQuestion += 1
            questionChanged()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        currentQuestion = sender.currentPage + 1
        questionChanged()
    }
    
    @IBAction func shouldClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
