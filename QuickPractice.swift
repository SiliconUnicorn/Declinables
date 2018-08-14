//
//  QuickPractice.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 3/18/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit
import DeclinablesLibrary

final class QuickPractice: UIViewController, Practiceable{
    var key: AnswerChecker? = nil
    var correctTitle = "Genitive Singular"
    var userInput = ""
    var memberNumber = 0
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var userAnswer: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userAnswer.delegate = self
    }
    
    func saveUserInput() {
        userInput = userAnswer.text!
        (parent!.parent! as! PracticeScreen).userAnswers[memberNumber] = userInput
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainTitle.text = correctTitle
        subtitle.text = "from: " + key!.displayName
        userAnswer.text = userInput
        
        //Fix issues with pageDots
        (parent!.parent! as! PracticeScreen).memberNumber = (parent!.parent! as! PracticeScreen).findMemberNumber(forController: self)
        (parent!.parent! as! PracticeScreen).pageDots.currentPage = (parent!.parent! as! PracticeScreen).memberNumber
        (parent!.parent! as! PracticeScreen).currentController = self
        
        memberNumber = (parent!.parent! as! PracticeScreen).memberNumber
        
        super.viewWillAppear(animated)
    }
}

extension QuickPractice: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        saveUserInput()
        return true
    }
}
