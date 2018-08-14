//
//  SetupController.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 2/22/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit
import DeclinablesLibrary

final class SetupController: UIViewController, DeclinablesControllerDelegate{
    var setupQuestionTotal = 5
    
    var questionList: [AnswerChecker] = []
    
    var firstDeclensionQuestions: [AnswerChecker] = []
    
    var secondDeclensionQuestions: [AnswerChecker] = []
    
    var thirdDeclensionQuestions: [AnswerChecker] = []
    
    var fourthDeclensionQuestions: [AnswerChecker] = []
    
    var fifthDeclensionQuestions: [AnswerChecker] = []
    
    var firstDeclensionEnabled = true
    
    var secondDeclensionEnabled = true
    
    var thirdDeclensionEnabled = true
    
    var fourthDeclensionEnabled = true
    
    var fifthDeclensionEnabled = true
    
    var scoreEnabled = true
    
    var testType = TestTypes.declinablesController
    
    @IBOutlet weak var questionNumberStepper: UIStepper!
    @IBOutlet weak var questionNumberText: UILabel!
    
    @IBOutlet weak var firstDeclensionSwitch: UISwitch!
    @IBOutlet weak var secondDeclensionSwitch: UISwitch!
    @IBOutlet weak var thirdDeclensionSwitch: UISwitch!
    @IBOutlet weak var fourthDeclensionSwitch: UISwitch!
    @IBOutlet weak var fifthDeclensionSwitch: UISwitch!
    
    @IBOutlet weak var scoreSwitch: UISwitch!
    
    @IBOutlet weak var firstDeclensionText: UILabel!
    @IBOutlet weak var secondDeclensionText: UILabel!
    @IBOutlet weak var thirdDeclensionText: UILabel!
    @IBOutlet weak var fourthDeclensionText: UILabel!
    @IBOutlet weak var fifthDeclensionText: UILabel!
    
    @IBOutlet weak var macronSwitch: UISwitch!
    
    fileprivate func disableDeclensions() {
        firstDeclensionEnabled = false
        secondDeclensionEnabled = false
        thirdDeclensionEnabled = false
        fourthDeclensionEnabled = false
        fifthDeclensionEnabled = false
    }
    
    var onSwitchCount: Int{
        var sudoCount = 0
        
        disableDeclensions()
        
        if firstDeclensionSwitch.isOn{
            sudoCount += 1
            firstDeclensionEnabled = true
        }
        if secondDeclensionSwitch.isOn{
            sudoCount += 1
            secondDeclensionEnabled = true
        }
        if thirdDeclensionSwitch.isOn{
            sudoCount += 1
            thirdDeclensionEnabled = true
        }
        if fourthDeclensionSwitch.isOn{
            sudoCount += 1
            fourthDeclensionEnabled = true
        }
        if fifthDeclensionSwitch.isOn{
            sudoCount += 1
            fifthDeclensionEnabled = true
        }
        return sudoCount
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ get{ return .lightContent}}
    
    func prepareQuestions(){
        let randomizer = Dice()
        questionList.removeAll()
        var generating = true
        var remainingFirstDeclensionOptions = firstDeclensionQuestions
        var remainingSecondDeclensionOptions = secondDeclensionQuestions
        var remainingThirdDeclensionOptions = thirdDeclensionQuestions
        var remainingFourthDeclensionOptions = fourthDeclensionQuestions
        var remainingFifthDeclensionOptions = fifthDeclensionQuestions
        
        var questionNumber = 0
        
        while generating{
            let randomValue = randomizer.rollD(5)
            if randomValue == 1 && firstDeclensionEnabled{
                questionNumber = randomizer.rollD(remainingFirstDeclensionOptions.count) - 1
                questionList.append(remainingFirstDeclensionOptions[questionNumber])
                remainingFirstDeclensionOptions.remove(at: questionNumber)
                
            }else if randomValue == 2 && secondDeclensionEnabled{
                questionNumber = randomizer.rollD(remainingSecondDeclensionOptions.count) - 1
                questionList.append(remainingSecondDeclensionOptions[questionNumber])
                remainingSecondDeclensionOptions.remove(at: questionNumber)
                
            }else if randomValue == 3 && thirdDeclensionEnabled{
                questionNumber = randomizer.rollD(remainingThirdDeclensionOptions.count) - 1
                questionList.append(remainingThirdDeclensionOptions[questionNumber])
                remainingThirdDeclensionOptions.remove(at: questionNumber)
                
            }else if randomValue == 4 && fourthDeclensionEnabled{
                questionNumber = randomizer.rollD(remainingFourthDeclensionOptions.count) - 1
                questionList.append(remainingFourthDeclensionOptions[questionNumber])
                remainingFourthDeclensionOptions.remove(at: questionNumber)
                
            }else if randomValue == 5 && fifthDeclensionEnabled{
                questionNumber = randomizer.rollD(remainingFifthDeclensionOptions.count) - 1
                questionList.append(remainingFifthDeclensionOptions[questionNumber])
                remainingFifthDeclensionOptions.remove(at: questionNumber)
            }
            if questionList.count >= setupQuestionTotal{
                generating = false
            }
        }
    }
    
    func copyQuestionsFromLoader(_ loader: CustomWordNavigator) {
        firstDeclensionQuestions = loader.firstDeclensionQuestions
        secondDeclensionQuestions = loader.secondDeclensionQuestions
        thirdDeclensionQuestions = loader.thirdDeclensionQuestions
        fourthDeclensionQuestions = loader.fourthDeclensionQuestions
        fifthDeclensionQuestions = loader.fifthDeclensionQuestions
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if parent is CustomWordNavigator{
            let loader = parent as! CustomWordNavigator
            copyQuestionsFromLoader(loader)
        }
        
        macronSwitch.isOn = storage.bool(forKey: "defaultScoreMacrons")
    }
    
    @IBAction func questionSettingChanged(_ sender: UIStepper) {
        setupQuestionTotal = Int(questionNumberStepper.value)
        if setupQuestionTotal != 1{
            questionNumberText.text = setupQuestionTotal.description + " Questions"
        } else {
            questionNumberText.text = "1 Question"
        }
    }
    
    @IBAction func macronSwitchChanged(_ sender: UISwitch) {
        if macronSwitch.isOn{
            storage.set(true, forKey: "scoreMacrons")
        } else {
            storage.set(false, forKey: "scoreMacrons")
        }
    }
    
    @IBAction func scoreSwitchChanged(_ sender: UISwitch) {
        if scoreSwitch.isOn{
            scoreEnabled = true
        } else {
            scoreEnabled = false
        }
    }
    
    ///Checking `onSwitchCount` also makes changes to the program. You must check the value of `onSwitchCount` in `switchChanged(_:)` unless you specifically make changes to the method as well.
    @IBAction func switchChanged(_ switch: UISwitch){
        firstDeclensionSwitch.isEnabled = true
        firstDeclensionText.isEnabled = true
        secondDeclensionSwitch.isEnabled = true
        secondDeclensionText.isEnabled = true
        thirdDeclensionSwitch.isEnabled = true
        thirdDeclensionText.isEnabled = true
        fourthDeclensionSwitch.isEnabled = true
        fourthDeclensionText.isEnabled = true
        fifthDeclensionSwitch.isEnabled = true
        fifthDeclensionText.isEnabled = true
        
        if onSwitchCount == 1{
            if firstDeclensionSwitch.isOn{
                firstDeclensionSwitch.isEnabled = false
                firstDeclensionText.isEnabled = false
            }
            if secondDeclensionSwitch.isOn{
                secondDeclensionSwitch.isEnabled = false
                secondDeclensionText.isEnabled = false
            }
            if thirdDeclensionSwitch.isOn{
                thirdDeclensionSwitch.isEnabled = false
                thirdDeclensionText.isEnabled = false
            }
            if fourthDeclensionSwitch.isOn{
                fourthDeclensionSwitch.isEnabled = false
                fourthDeclensionText.isEnabled = false
            }
            if fifthDeclensionSwitch.isOn{
                fifthDeclensionSwitch.isEnabled = false
                fifthDeclensionText.isEnabled = false
            }
        }
    }
    func savePracticeComponents() {
        prepareQuestions()
        
        (parent as! CustomWordNavigator).firstDeclensionEnabled = firstDeclensionEnabled
        (parent as! CustomWordNavigator).secondDeclensionEnabled = secondDeclensionEnabled
        (parent as! CustomWordNavigator).thirdDeclensionEnabled = thirdDeclensionEnabled
        (parent as! CustomWordNavigator).fourthDeclensionEnabled = fourthDeclensionEnabled
        (parent as! CustomWordNavigator).fifthDeclensionEnabled = fifthDeclensionEnabled
        
        (parent as! CustomWordNavigator).questionList = questionList
        (parent as! CustomWordNavigator).setupQuestionTotal = setupQuestionTotal
        (parent as! CustomWordNavigator).scoreEnabled = scoreEnabled
        
        (parent as! CustomWordNavigator).testType = .declinablesController
    }
    
    @IBAction func startPractice(_ sender: UIButton) {
        savePracticeComponents()
        navigationController!.pushViewController(storyboard!.instantiateViewController(withIdentifier: "NewPractice"), animated: true)
    }
}
