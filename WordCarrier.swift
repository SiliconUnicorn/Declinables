//
//  WordCarrier.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 2/22/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import DeclinablesLibrary

protocol WordCarrier{
    //MARK: Stored Properties
    var firstDeclensionQuestions: [AnswerChecker] {get set}
    var secondDeclensionQuestions: [AnswerChecker] {get set}
    var thirdDeclensionQuestions: [AnswerChecker] {get set}
    var fourthDeclensionQuestions: [AnswerChecker] {get set}
    var fifthDeclensionQuestions: [AnswerChecker] {get set}
    
    //MARK: Computed Properties
    var questionList: [AnswerChecker] {get}
}

extension WordCarrier{
    var questionList: [AnswerChecker] { get{ return firstDeclensionQuestions + secondDeclensionQuestions + thirdDeclensionQuestions + fourthDeclensionQuestions + fifthDeclensionQuestions}}
}
