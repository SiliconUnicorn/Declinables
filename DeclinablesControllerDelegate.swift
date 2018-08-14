//
//  DeclinablesControllerDelegate.swift
//  Declinables
//
//  Created by Micah Hansonbrook on 1/6/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import DeclinablesLibrary

protocol DeclinablesControllerDelegate{
    var setupQuestionTotal: Int {get set}
    var questionList: [AnswerChecker] {get set}
    var firstDeclensionQuestions: [AnswerChecker] {get set}
    var secondDeclensionQuestions: [AnswerChecker] {get set}
    var thirdDeclensionQuestions: [AnswerChecker] {get set}
    var fourthDeclensionQuestions: [AnswerChecker] {get set}
    var fifthDeclensionQuestions: [AnswerChecker] {get set}
    var firstDeclensionEnabled: Bool {get set}
    var secondDeclensionEnabled: Bool {get set}
    var thirdDeclensionEnabled: Bool {get set}
    var scoreEnabled: Bool {get set}
    var testType: TestTypes {get set}
}

