//
//  ResultsDelegate.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 2/11/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import DeclinablesLibrary

protocol ResultsDelegate{
    var resultsToGrade: [AnswerChecker]{ get set}
    var testType: TestTypes {get set}
    var totalQuestions: Int {get set}
    var singleQuestionAnswers: [String?] {get set}
    var singleQuestionForms: [PossibleDeclensions] {get set}
}
