//
//  QuickComparisonPage.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 3/26/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit
import DeclinablesLibrary

final class QuickComparisonPage: UIViewController{
    var currentQuestion = 1
    var form = PossibleDeclensions.singularNominative
    var userAnswerText = ""
    var answerKey = AnswerChecker("Puella", "Puellae")
    
    var questionNumber = 0
    
    @IBOutlet weak var formField: UILabel!
    @IBOutlet weak var nounField: UILabel!
    
    @IBOutlet weak var correctAnswer: UILabel!
    @IBOutlet weak var userAnswer: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        formField.text = form.description
        nounField.text = "from " + answerKey.displayName
        if answerKey.correctAnswers[form.numericForm].lowercased() != userAnswerText.lowercased(){
            correctAnswer.text = "Correct Answer: \"" + answerKey.correctAnswers[form.numericForm] + "\""
            correctAnswer.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            userAnswer.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else {
            correctAnswer.text = "Your Answer was Correct"
            correctAnswer.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            userAnswer.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        if userAnswerText != ""{
            userAnswer.text = "Your Answer: \"" + userAnswerText + "\""
        } else {
            userAnswer.text = "You Did Not Answer"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        (parent!.parent as! AnswerComparison).currentQuestion = currentQuestion
        (parent!.parent as! AnswerComparison).pageDots.currentPage = currentQuestion
    }
}
