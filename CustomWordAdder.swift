//
//  CustomWordAdder.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 1/15/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit
import DeclinablesLibrary

final class CustomWordAdder: UIViewController, DeclinablesControllerDelegate{
    
    let storage = UserDefaults()
    
    var scoreEnabled = true
    
    var setupQuestionTotal = 1
    
    var questionList = [AnswerChecker("Puella", "Puellae")]
    
    var firstDeclensionQuestions = [AnswerChecker("Puella", "Puellae")]
    
    var secondDeclensionQuestions = [AnswerChecker("Populus", "Populi")]
    
    var thirdDeclensionQuestions = [AnswerChecker("Rex", "Regis")]
    
    var fourthDeclensionQuestions: [AnswerChecker] = []
    
    var fifthDeclensionQuestions: [AnswerChecker] = []
    
    
    
    var firstDeclensionEnabled = false
    
    var secondDeclensionEnabled = false
    
    var thirdDeclensionEnabled = false
    
    var fourthDeclensionEnabled = false
    
    var fifthDeclensionEnabled = false
    
    
    
    var testType = TestTypes.declinablesController
    
    var singularGenitiveFieldAltered = false
    
    @IBOutlet weak var saveWordButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var viewEndingsButton: UIButton!
    
    @IBOutlet weak var root: UITextField!
    @IBOutlet weak var genitiveSingularRootComponent: UITextField!
    @IBOutlet weak var practiceWordButton: UIButton!
    
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        genderSegment.isEnabled = false
        
        root.delegate = self
        genitiveSingularRootComponent.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        firstDeclensionQuestions.removeAll()
        secondDeclensionQuestions.removeAll()
        thirdDeclensionQuestions.removeAll()
        fourthDeclensionQuestions.removeAll()
        fifthDeclensionQuestions.removeAll()
        super.viewWillAppear(animated)
        
        let questionsToChange = storage.array(forKey: "userQuestions")
        var userQuestions: [String] = []
        
        if questionsToChange is [String]{
            userQuestions = questionsToChange as! [String]
            if userQuestions.contains(AnswerChecker(root.text!, genitiveSingularRootComponent.text!).displayName){
                saveWordButton.setTitle("Delete Word", for: .normal)
                saveWordButton.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
            } else {
                saveWordButton.setTitle("Save Word", for: .normal)
                saveWordButton.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            }
        }
    }
    
    @IBAction func practiceWord(_ sender: UIButton) {
        (navigationController! as! CustomWordNavigator).questionList = questionList
        (navigationController! as! CustomWordNavigator).totalQuestions = 1
        if storage.string(forKey: "defaultMode")! == "quickPractice" {
            (navigationController as! CustomWordNavigator).testType = .singleQuestionMode
        } else {
            (navigationController as! CustomWordNavigator).testType = .declinablesController
        }
        
        storage.set(storage.bool(forKey: "defaultScoreMacrons"), forKey: "scoreMacrons")
        
        prepareToDecline()
        navigationController!.pushViewController(storyboard!.instantiateViewController(withIdentifier: "NewPractice"), animated: true)
    }
    
    fileprivate func prepareToDecline() {
        guard root.text != "" && genitiveSingularRootComponent.text != "" else{
            return
        }
        questionList.removeAll()
        
        var speculativeNominative = root.text
        var speculativeGenitive = genitiveSingularRootComponent.text
        var firstLetter = "A"
        var wordRemainder = "test"
        
        speculativeNominative = speculativeNominative!.lowercased()
        speculativeGenitive = speculativeGenitive?.lowercased()
        
        firstLetter.removeAll()
        firstLetter.append(speculativeNominative!.first!)
        firstLetter = firstLetter.capitalized
        speculativeNominative!.removeFirst()
        wordRemainder = speculativeNominative!
        speculativeNominative = firstLetter + wordRemainder
        
        firstLetter.removeAll()
        firstLetter.append(speculativeGenitive!.first!)
        firstLetter = firstLetter.capitalized
        speculativeGenitive!.removeFirst()
        wordRemainder = speculativeGenitive!
        speculativeGenitive = firstLetter + wordRemainder
        
        firstDeclensionEnabled = false
        secondDeclensionEnabled = false
        thirdDeclensionEnabled = false
        fourthDeclensionEnabled = false
        fifthDeclensionEnabled = false
        
        firstDeclensionQuestions.removeAll()
        secondDeclensionQuestions.removeAll()
        thirdDeclensionQuestions.removeAll()
        fourthDeclensionQuestions.removeAll()
        fifthDeclensionQuestions.removeAll()
        
        var newWord = AnswerChecker(speculativeNominative!, speculativeGenitive!)
        
        if genderSegment.selectedSegmentIndex == 2{
            newWord.isNeuter = true
        }else if genderSegment.selectedSegmentIndex == 1{
            newWord.thirdGenderLetter = "F"
        }
        
        if newWord.declensionNumber == 1 || newWord.declensionNumber == 5{
            genderSegment.selectedSegmentIndex = 1
        }else if newWord.isNeuter{
            genderSegment.selectedSegmentIndex = 2
        }
        
        switch newWord.declensionNumber{
        case 1: firstDeclensionQuestions.append(newWord); questionList = firstDeclensionQuestions; firstDeclensionEnabled = true
        case 2: secondDeclensionQuestions.append(newWord); questionList = secondDeclensionQuestions; secondDeclensionEnabled = true
        case 3: thirdDeclensionQuestions.append(newWord); questionList = thirdDeclensionQuestions; thirdDeclensionEnabled = true
        case 4: fourthDeclensionQuestions.append(newWord); questionList = fourthDeclensionQuestions; fourthDeclensionEnabled = true
        case 5: fifthDeclensionQuestions.append(newWord); questionList = fifthDeclensionQuestions; fifthDeclensionEnabled = true
        default: return
        }
    }
    
    func canSaveWord(_ word: String) -> Bool{
        //Prepares a new word.
        prepareToDecline()
        let newWord = questionList[0]
        
        let questionsToChange = storage.array(forKey: "userQuestions")
        var userQuestions: [String] = []
        
        if questionsToChange is [String]{
            userQuestions = questionsToChange as! [String]
        } else {
            return false
        }
        
        if userQuestions.index(of: newWord.displayName.lowercased()) == nil{
            return true
        } else {
            return false
        }
    }
    
    @IBAction func genderSegmentUpdated(_ sender: UISegmentedControl) {
        prepareToDecline()
    }
    
    @IBAction func shouldSaveWord(_ sender: UIButton){
        
        //Prepares a new word.
        prepareToDecline()
        var newWord = questionList[0]
        
        if genderSegment.selectedSegmentIndex == 2{
            newWord.isNeuter = true
        }else if genderSegment.selectedSegmentIndex == 1{
            newWord.thirdGenderLetter = "F"
        }
        
        let questionsToChange = storage.array(forKey: "userQuestions")
        var userQuestions: [String] = []
        
        if questionsToChange is [String]{
            userQuestions = questionsToChange as! [String]
        } else {
            userQuestions = ["Error, Erroris (E)"]
        }
        
        if sender.titleLabel?.text! == "Save Word"{
            guard !(userQuestions.contains(newWord.displayName) || userQuestions.contains(newWord.displayName.lowercased())) else{
                sender.setTitle("Delete Word", for: .normal)
                return
            }
            
            if userQuestions.count == 1 && userQuestions.index(of: "Error, Erroris (E)") != nil{
                userQuestions.remove(at: userQuestions.index(of: "Error, Erroris (E)")!)
            }
            
            userQuestions.append(newWord.displayName.lowercased())
            
            sender.setTitle("Delete Word", for: .normal)
            sender.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
            
        }else if sender.titleLabel?.text! == "Delete Word"{
            guard userQuestions.contains(newWord.displayName) else{
                sender.setTitle("Save Word", for: .normal)
                return
            }
            
            userQuestions.remove(at: userQuestions.index(of: newWord.displayName)!)
            
            sender.setTitle("Save Word", for: .normal)
            sender.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
        
        defer{
            storage.set(userQuestions, forKey: "userQuestions")
        }
    }
    @IBAction func viewEndings(_ sender: UIButton) {
        
    }
}

extension CustomWordAdder: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == root{
            genitiveSingularRootComponent.becomeFirstResponder()
        } else {
            standardUpdate(textField)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        practiceWordButton.isEnabled = false
        saveWordButton.isEnabled = false
        genderSegment.isEnabled = false
        genderSegment.isEnabled = false
    }
    
    func standardUpdate(_ textField: UITextField) {
        prepareToDecline()
        //Removes old questions to prevent problems from occuring.
        firstDeclensionQuestions.removeAll()
        secondDeclensionQuestions.removeAll()
        thirdDeclensionQuestions.removeAll()
        fourthDeclensionQuestions.removeAll()
        fifthDeclensionQuestions.removeAll()
        
        
        if root.text != nil && genitiveSingularRootComponent != nil && (genitiveSingularRootComponent.text!.lowercased().hasSuffix("ae") || (genitiveSingularRootComponent.text!.lowercased().hasSuffix("i") && (root.text!.lowercased().hasSuffix("us") || root.text!.lowercased().hasSuffix("um") || root.text!.lowercased().hasSuffix("r"))) || genitiveSingularRootComponent.text!.lowercased().hasSuffix("is")) || (root.text!.lowercased().hasSuffix("us") && genitiveSingularRootComponent.text!.lowercased().hasSuffix("us")) || (root.text!.lowercased().hasSuffix("us") && genitiveSingularRootComponent.text!.lowercased().hasSuffix("ūs")) || (genitiveSingularRootComponent.text!.lowercased().hasSuffix("ei") && root.text!.lowercased().hasSuffix("es")) || (genitiveSingularRootComponent.text!.lowercased().hasSuffix("eī") && root.text!.lowercased().hasSuffix("es")){
            
            //Creates the word
            prepareToDecline()
            
            //Enables practicing the word
            practiceWordButton.isEnabled = true
            
            //Sets up the save button.
            saveWordButton.isEnabled = true
            if canSaveWord(AnswerChecker(root.text!, genitiveSingularRootComponent.text!).displayName){
                saveWordButton.setTitle("Save Word", for: .normal)
                saveWordButton.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            } else {
                saveWordButton.setTitle("Delete Word", for: .normal)
                saveWordButton.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
            }
            
            //Prepares the neuter switch.
            if genitiveSingularRootComponent.text!.hasSuffix("is"){
                if storage.bool(forKey: "hasCustomizedThirdPreviously") != true{
                    
                    storage.set(true, forKey: "hasCustomizedThirdPreviously")
                    
                    //Presents onetime message to the user.
                    let message = UIAlertController(title: "Third Declension Words", message: "When adding a custom third declension word you will need to set its gender from the three segments below where you enter the root.", preferredStyle: .alert)
                    let okayButton = UIAlertAction(title: "Don't Show Again", style: .cancel, handler: nil)
                    message.addAction(okayButton)
                    present(message, animated: true, completion: nil)
                }
                genderSegment.isEnabled = true
            } else {
                genderSegment.selectedSegmentIndex = 0
            }
            
            if genitiveSingularRootComponent.text!.hasSuffix("i"){
                if root.text!.hasSuffix("um"){
                    genderSegment.selectedSegmentIndex = 2
                } else {
                    genderSegment.selectedSegmentIndex = 0
                }
            }
            
            if genitiveSingularRootComponent.text!.hasSuffix("ūs") || genitiveSingularRootComponent.text!.hasSuffix("us"){
                if root.text!.hasSuffix("ū"){
                    genderSegment.selectedSegmentIndex = 2
                } else {
                    genderSegment.selectedSegmentIndex = 0
                }
            }
        }
        
        //Presents error messages, if neccessary
        if (root.text == nil || root.text == "") && (genitiveSingularRootComponent.text == nil || genitiveSingularRootComponent.text == ""){
            errorMessage.isHidden = false
            errorMessage.text = "Both Textfields Must Be Filled"
            
        }else if root.text == nil || root.text == ""{
            errorMessage.isHidden = false
            errorMessage.text = "You Must Fill the Singular Nominative Field"
            
        }else if singularGenitiveFieldAltered && (genitiveSingularRootComponent.text == nil || genitiveSingularRootComponent.text == ""){
            errorMessage.isHidden = false
            errorMessage.text = "You Must Fill the Singular Genitive Field"
            
        }else if singularGenitiveFieldAltered && genitiveSingularRootComponent.text!.hasSuffix("ae") == false && genitiveSingularRootComponent.text!.hasSuffix("i") == false && genitiveSingularRootComponent.text!.hasSuffix("is") == false && genitiveSingularRootComponent.text!.hasSuffix("us") == false && genitiveSingularRootComponent.text!.hasSuffix("ūs") == false && genitiveSingularRootComponent.text!.hasSuffix("ei") == false{
            errorMessage.isHidden = false
            errorMessage.text = "Invalid Singular Genitive Entry"
            
        }else if genitiveSingularRootComponent.text!.hasSuffix("i") && genitiveSingularRootComponent.text!.hasSuffix("ei") == false && root.text!.hasSuffix("um") == false && root.text!.hasSuffix("us") == false && root.text!.hasSuffix("r") == false{
            errorMessage.isHidden = false
            errorMessage.text = "Nominative Ending Must be ”us,“ ”um,“ or ”r“ for Second Declension"
        } else {
            errorMessage.isHidden = true
        }
        
        
        //Checks to see if singularGenitiveFieldAltered should be changed, depending on the textfield.
        if textField == genitiveSingularRootComponent{
            singularGenitiveFieldAltered = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        standardUpdate(textField)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        standardUpdate(textField)
    }
}
