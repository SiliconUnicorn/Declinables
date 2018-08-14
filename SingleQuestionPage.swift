//
//  SingleQuestionPage.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 3/18/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import UIKit
import DeclinablesLibrary

class SingleQuestionPage: UIViewController{
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var answerField: UITextField!
    
    weak var key: AnswerChecker? = nil
    var questionMode = PossibleDeclensions.singularNominative
    
    var correctAnswer: String?{ if key != nil{ return questionMode.correctEnding(inDeclension: key!.correctRoot.2) }else{ return nil}}
    var userInput: String? { return answerField.text}
    
    override func viewDidLoad() {
        answerField.delegate = self
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleText.text = questionMode.description
        super.viewWillAppear(animated)
    }
}

extension SingleQuestionPage: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
