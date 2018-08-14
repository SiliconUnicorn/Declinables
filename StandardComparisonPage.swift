//
//  StandardComparisonPage.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 3/26/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit
import DeclinablesLibrary

final class StandardComparisonPage: UIViewController{
    var questionNumber = 0
    ///The number of buttons that were incorrect
    var buttonsIncorrect = 0
    
    ///The number of buttons showing incorrect answers.
    var buttonsShowingIncorrect = 0
    
    var shouldSetup = true
    
    @IBOutlet weak var singularNominativeButton: ButtonComparer!
    @IBOutlet weak var singularGenitiveButton: ButtonComparer!
    @IBOutlet weak var singularDativeButton: ButtonComparer!
    @IBOutlet weak var singularAccusativeButton: ButtonComparer!
    @IBOutlet weak var singularAblativeButton: ButtonComparer!
    @IBOutlet weak var singularVocativeButton: ButtonComparer!
    @IBOutlet weak var pluralNominativeButton: ButtonComparer!
    @IBOutlet weak var pluralGenitiveButton: ButtonComparer!
    @IBOutlet weak var pluralDativeButton: ButtonComparer!
    @IBOutlet weak var pluralAccusativeButton: ButtonComparer!
    @IBOutlet weak var pluralAblativeButton: ButtonComparer!
    @IBOutlet weak var pluralVocativeButton: ButtonComparer!
    
    var buttonsList: [ButtonComparer] = [ButtonComparer()]
    
    var answerKey = AnswerChecker("Puella", "Puellae")
    
    override func viewDidAppear(_ animated: Bool) {
        (parent!.parent as! AnswerComparison).currentQuestion = questionNumber
        (parent!.parent as! AnswerComparison).pageDots.currentPage = questionNumber
        (parent!.parent as! AnswerComparison).latinRootTitle.text = answerKey.displayName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldSetup{
            setupComparison()
            shouldSetup = false
        }
    }
    
    fileprivate func buttonConverter() {
        var buttonIteration = 0
        
        for button in buttonsList{
            button.correctAnswer = answerKey.correctAnswers[buttonIteration]
            
            if AnswerChecker.shouldDisplayLowercased{
                button.correctAnswer = button.correctAnswer!.lowercased()
            }
            button.userAnswer = answerKey.userAnswers[buttonIteration]
            if button.noUserAnswerEntered || button.userAnswer == ""{
                button.setTitle("No Entry", for: .normal)
                button.setTitleColor(#colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1), for: .normal)
                if storage.bool(forKey: "scoreMacrons"){
                    button.setTitle(button.correctAnswer, for: .highlighted)
                } else {
                    button.setTitle(button.correctAnswer?.removeMacrons(), for: .highlighted)
                }
                button.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .highlighted)
                
                buttonsIncorrect += 1
                buttonsShowingIncorrect += 1
            } else {
                if button.userAnswerIsCorrect{
                    if storage.bool(forKey: "scoreMacrons"){
                        button.setTitle(button.correctAnswer, for: .normal)
                    } else {
                        button.setTitle(button.correctAnswer?.removeMacrons(), for: .normal)
                    }
                    button.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
                } else {
                    button.setTitle("\"" + button.userAnswer! + "\"", for: .normal)
                    button.setTitleColor(#colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1), for: .normal)
                    if storage.bool(forKey: "scoreMacrons"){
                        button.setTitle(button.correctAnswer, for: .highlighted)
                    } else {
                        button.setTitle(button.correctAnswer?.removeMacrons(), for: .highlighted)
                    }
                    button.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .highlighted)
                    
                    buttonsIncorrect += 1
                    buttonsShowingIncorrect += 1
                }
            }
            buttonIteration += 1
        }
    }
    
    func setupComparison() {
        //Resets the buttonsList
        buttonsList.removeAll()
        buttonsList.reserveCapacity(12)
        buttonsList = [singularNominativeButton, singularGenitiveButton, singularDativeButton, singularAccusativeButton, singularAblativeButton, singularVocativeButton, pluralNominativeButton, pluralGenitiveButton, pluralDativeButton, pluralAccusativeButton, pluralAblativeButton, pluralVocativeButton]
        
        buttonConverter()
    }
    
    fileprivate func showCorrect(_ sender: ButtonComparer) {
        if sender.noUserAnswerEntered || sender.userAnswer == ""{
            sender.setTitle("No Entry", for: .highlighted)
            sender.setTitleColor(#colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1), for: .highlighted)
            if storage.bool(forKey: "scoreMacrons"){
                sender.setTitle(sender.correctAnswer, for: .normal)
            } else {
                sender.setTitle(sender.correctAnswer?.removeMacrons(), for: .normal)
            }
            sender.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .normal)
            
            buttonsShowingIncorrect -= 1
        } else {
            if sender.userAnswerIsCorrect{
                if storage.bool(forKey: "scoreMacrons"){
                    sender.setTitle(sender.correctAnswer, for: .highlighted)
                } else {
                    sender.setTitle(sender.correctAnswer?.removeMacrons(), for: .highlighted)
                }
                sender.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .highlighted)
            } else {
                if storage.bool(forKey: "scoreMacrons"){
                    sender.setTitle("\"" + sender.userAnswer! + "\"", for: .highlighted)
                    sender.setTitleColor(#colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1), for: .highlighted)
                    
                    if storage.bool(forKey: "scoreMacrons"){
                        sender.setTitle(sender.correctAnswer, for: .normal)
                    } else {
                        sender.setTitle(sender.correctAnswer?.removeMacrons(), for: .normal)
                    }
                    sender.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .normal)
                    
                    buttonsShowingIncorrect -= 1
                }
            }
        }
    }
    
    fileprivate func showIncorrect(_ sender: ButtonComparer) {
        if sender.noUserAnswerEntered || sender.userAnswer == ""{
            sender.setTitle("No Entry", for: .normal)
            sender.setTitleColor(#colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1), for: .normal)
            if storage.bool(forKey: "scoreMacrons"){
                sender.setTitle(sender.correctAnswer, for: .highlighted)
            } else {
                sender.setTitle(sender.correctAnswer?.removeMacrons(), for: .highlighted)
            }
            sender.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .highlighted)
            
            buttonsShowingIncorrect += 1
        } else {
            if sender.userAnswerIsCorrect{
                
                if storage.bool(forKey: "scoreMacrons"){
                    sender.setTitle(sender.correctAnswer, for: .normal)
                } else {
                    sender.setTitle(sender.correctAnswer?.removeMacrons(), for: .normal)
                }
                sender.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
                
            } else {
                sender.setTitle("\"" + sender.userAnswer! + "\"", for: .normal)
                sender.setTitleColor(#colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1), for: .normal)
                if storage.bool(forKey: "scoreMacrons"){
                    sender.setTitle(sender.correctAnswer, for: .highlighted)
                } else {
                    sender.setTitle(sender.correctAnswer?.removeMacrons(), for: .highlighted)
                }
                sender.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .highlighted)
                
                buttonsShowingIncorrect += 1
            }
        }
    }
    
    @IBAction func buttonActivated(_ sender: ButtonComparer) {
        var userEntry = ""
        if sender.userAnswer != nil{
            userEntry = sender.userAnswer!
        }
        if sender.title(for: .normal) == "No Entry" || sender.title(for: .normal) == "\"" + userEntry + "\"" {
            showCorrect(sender)
        } else {
            showIncorrect(sender)
        }
    }
    
    @IBAction func disclosureButtonActivated(_ sender: UIButton) {
        if sender.titleLabel?.text == "Show All"{
            sender.setTitle("Hide All", for: .normal)
            for member in buttonsList{
                showCorrect(member)
                buttonsShowingIncorrect = 0
            }
        } else {
            sender.setTitle("Show All", for: .normal)
            for member in buttonsList{
                showIncorrect(member)
            }
            buttonsShowingIncorrect = buttonsIncorrect
        }
    }
}
