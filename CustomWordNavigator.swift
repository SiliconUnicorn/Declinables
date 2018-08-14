//
//  CustomWordNavigator.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 2/7/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit
import DeclinablesLibrary

final class CustomWordNavigator: UINavigationController, DeclinablesControllerDelegate, ResultsDelegate{
    var resultsToGrade = [AnswerChecker("Puella", "Puellae")]
    
    var testType = TestTypes.declinablesController
    
    var totalQuestions = 1
    
    var singleQuestionAnswers: [String?] = ["None"]
    
    var singleQuestionForms = [PossibleDeclensions.singularNominative]
    
    var setupQuestionTotal = 1
    
    var questionList = [AnswerChecker("Puella", "Puellae")]
    
    var firstDeclensionQuestions = [AnswerChecker("Puella", "Puellae")]
    
    var secondDeclensionQuestions = [AnswerChecker("Puella", "Puellae")]
    
    var thirdDeclensionQuestions = [AnswerChecker("Puella", "Puellae")]
    
    var fourthDeclensionQuestions: [AnswerChecker] = []
    
    var fifthDeclensionQuestions: [AnswerChecker] = []
    
    var firstDeclensionEnabled = false
    
    var secondDeclensionEnabled = false
    
    var thirdDeclensionEnabled = false
    
    var fourthDeclensionEnabled = false
    
    var fifthDeclensionEnabled = false
    
    var scoreEnabled = true
    
    internal var hiddenStatusStyle = UIStatusBarStyle.lightContent
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ return hiddenStatusStyle}
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{ return .fade}
}

extension UINavigationController{
    var previousViewController: UIViewController?{ if viewControllers.count >= 1{return viewControllers[viewControllers.count - 2]} else { return nil}}
}
