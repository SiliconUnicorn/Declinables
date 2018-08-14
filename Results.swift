//
//  Results.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 1/15/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit
import DeclinablesLibrary
import StoreKit

final class Results: UIViewController{
    
    //Will be reset by presented views.
    var shouldConsiderReview = false
    var didRequestReview = false
    
    //Checks for saving scores.
    var firstTimeOpened = true
    
    //Enables Storage
    let storage = UserDefaults()
    
    weak var presenter: UIViewController? = nil
    
    let storyboardLoader = UIStoryboard(name: "Main", bundle: nil)
    
    //Used only for Single Question Mode
    var singleQuestionAnswers: [String?] = [nil]
    var singleQuestionForms: [PossibleDeclensions] = [.singularNominative]
    
    var resultsToGrade = [AnswerChecker("Puella", "Puellae")]
    var correctAnswers = 0
    var totalQuestions = 0
    var percentageScore = 0
    
    var firstDeclensionIncorrect = 0
    var secondDeclensionIncorrect = 0
    var thirdDeclensionIncorrect = 0
    var fourthDeclensionIncorrect = 0
    var fifthDeclensionIncorrect = 0
    
    var firstDeclensionTotal = 0
    var secondDeclensionTotal = 0
    var thirdDeclensionTotal = 0
    var fourthDeclensionTotal = 0
    var fifthDeclensionTotal = 0
    
    var getFirstDeclensionPercentage: Double{ return Double(firstDeclensionTotal - firstDeclensionIncorrect)/Double(firstDeclensionTotal)}
    var getSecondDeclensionPercentage: Double{ return Double(secondDeclensionTotal - secondDeclensionIncorrect)/Double(secondDeclensionTotal)}
    var getThirdDeclensionPercentage: Double{ return Double(thirdDeclensionTotal - thirdDeclensionIncorrect)/Double(thirdDeclensionTotal)}
    var getFourthDeclensionPercentage: Double{ return Double(fourthDeclensionTotal - fourthDeclensionIncorrect)/Double(fourthDeclensionTotal)}
    var getFifthDeclensionPercentage: Double{ return Double(fifthDeclensionTotal - fifthDeclensionIncorrect)/Double(fifthDeclensionTotal)}
    
    var usedDeclensionsCount: Int{
        var speculativeValue = 0
        
        if firstDeclensionTotal > 0{
            speculativeValue += 1
        }
        if secondDeclensionTotal > 0{
            speculativeValue += 1
        }
        if thirdDeclensionTotal > 0{
            speculativeValue += 1
        }
        if fourthDeclensionTotal > 0{
            speculativeValue += 1
        }
        if fifthDeclensionTotal > 0{
            speculativeValue += 1
        }
        return speculativeValue
    }
    
    var loader: DeclinablesControllerDelegate? = nil
    
    var testType = TestTypes.declinablesController
    
    @IBOutlet weak var compareAnswersButton: UIButton!
    
    @IBOutlet weak var letterGrade: UILabel!
    @IBOutlet weak var percentRight: UILabel!
    @IBOutlet weak var feedbackText: UITextView!
    
    @IBOutlet weak var embeddedStandardComparison: UIView!
    @IBOutlet weak var embeddedSingleQuestionComparision: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard !(navigationController?.previousViewController is MainMenu) && !(navigationController?.previousViewController is Results) && !(navigationController?.previousViewController is SetupController) else{
            navigationController?.popViewController(animated: false)
            return
        }
        
        if parent == nil{
            presenter = presentingViewController
        } else {
            presenter = (parent! as! CustomWordNavigator).viewControllers[(parent! as! CustomWordNavigator).viewControllers.count - 2]
            (navigationController?.previousViewController as! PracticeScreen).allowShowing = false
        }
        
        if presenter is PracticeScreen{
            testType = (presenter as! PracticeScreen).testType
            switch testType{
            case .declinablesController: showDeclinablesControllerResults(); embeddedSingleQuestionComparision.isHidden = true
            case .singleQuestionMode: showSingleQuestionModeResults(); embeddedStandardComparison.isHidden = true
            }
        }
        
        super.viewWillAppear(animated)
        
        let random = Dice()
        if shouldConsiderReview && percentageScore >= 95 && didRequestReview == false && random.nextBool{
            if #available(iOS 10.3, *) { SKStoreReviewController.requestReview() }
            didRequestReview = true
        }
        
        // Makes sure that the Results are not accidently copied to record too many times.
        if firstTimeOpened{
            firstTimeOpened = false
            
            storage.set(storage.integer(forKey: "totalCorrect") + correctAnswers, forKey: "totalCorrect")
            storage.set(storage.integer(forKey: "totalQuestions") + totalQuestions, forKey: "totalQuestions")
            
            storage.set(storage.integer(forKey: "firstDeclensionTotal") + firstDeclensionTotal, forKey: "firstDeclensionTotal")
            storage.set(storage.integer(forKey: "secondDeclensionTotal") + secondDeclensionTotal, forKey: "secondDeclensionTotal")
            storage.set(storage.integer(forKey: "thirdDeclensionTotal") + thirdDeclensionTotal, forKey: "thirdDeclensionTotal")
            storage.set(storage.integer(forKey: "fourthDeclensionTotal") + fourthDeclensionTotal, forKey: "fourthDeclensionTotal")
            storage.set(storage.integer(forKey: "fifthDeclensionTotal") + fifthDeclensionTotal, forKey: "fifthDeclensionTotal")
            
            storage.set(storage.integer(forKey: "firstDeclensionCorrect") + (firstDeclensionTotal - firstDeclensionIncorrect), forKey: "firstDeclensionCorrect")
            storage.set(storage.integer(forKey: "secondDeclensionCorrect") + (secondDeclensionTotal - secondDeclensionIncorrect), forKey: "secondDeclensionCorrect")
            storage.set(storage.integer(forKey: "thirdDeclensionCorrect") + (thirdDeclensionTotal - secondDeclensionIncorrect), forKey: "thirdDeclensionCorrect")
            storage.set(storage.integer(forKey: "fourthDeclensionCorrect") + (fourthDeclensionTotal - fourthDeclensionIncorrect), forKey: "fourthDeclensionCorrect")
            storage.set(storage.integer(forKey: "fifthDeclensionCorrect") + (fifthDeclensionTotal - fifthDeclensionIncorrect), forKey: "fifthDeclensionCorrect")
            
            storage.set(storage.integer(forKey: "firstDeclensionIncorrect") + firstDeclensionIncorrect, forKey: "firstDeclensionIncorrect")
            storage.set(storage.integer(forKey: "secondDeclensionIncorrect") + secondDeclensionIncorrect, forKey: "secondDeclensionIncorrect")
            storage.set(storage.integer(forKey: "thirdDeclensionIncorrect") + thirdDeclensionIncorrect, forKey: "thirdDeclensionIncorrect")
            storage.set(storage.integer(forKey: "fourthDeclensionIncorrect") + fourthDeclensionIncorrect, forKey: "fourthDeclensionIncorrect")
            storage.set(storage.integer(forKey: "fifthDeclensionIncorrect") + fifthDeclensionIncorrect, forKey: "fifthDeclensionIncorrect")
        }
    }
    
    fileprivate func generateFeedback() {
        percentRight.text = String(percentageScore) + "% Correct"
        
        if percentageScore < 60{
            letterGrade.text = "F"; feedbackText.text = "Even if things don't always go right you can always review and keep on practicing. Use the declensions chart to review and then try again."
            if percentageScore == 0{
                feedbackText.text = "You only got 0%. Unless you accidently clicked through the declensions to quickly, you should consider reviewing your declensions using the button below."
            }
        }else if percentageScore >= 100{
            letterGrade.text = "A+"; feedbackText.text = "Excellent job on your latest declining practice. Things couldn't have gone any better! Remember to pratice every once in a while to maintain your skill level."
        } else {
            switch String(percentageScore).prefix(1){
            case "6": letterGrade.text = "D"; feedbackText.text = "Things could have gone better. Review your notes and keep on practicing."
            case "7": letterGrade.text = "C"; feedbackText.text = "Disappointments happen to everyone. Review your notes and keep on practicing."
            case "8": letterGrade.text = "B"; feedbackText.text = "Things went okay. Consider reviewing your notes and don't forget to keep on practicing."
            case "9": letterGrade.text = "A"; feedbackText.text = "Excellent job on your latest declining practice! Keep on practicing to maintain your skill level."
            default: letterGrade.text = "A"
            }
            switch String(percentageScore).suffix(1){
            case "0": letterGrade.text?.append("-")
            case "1": letterGrade.text?.append("-")
            case "2": letterGrade.text?.append("-")
            case "7": letterGrade.text?.append("+")
            case "8": letterGrade.text?.append("+")
            case "9": letterGrade.text?.append("+"); feedbackText.text.append(" You've almost reached a whole new letter; just a little bit more to go!")
            default: break
            }
        }
        if percentageScore != 0{
            if usedDeclensionsCount > 2{
                if getFirstDeclensionPercentage < getSecondDeclensionPercentage && getFirstDeclensionPercentage < getThirdDeclensionPercentage && getFirstDeclensionPercentage < getFourthDeclensionPercentage && getFirstDeclensionPercentage < getFifthDeclensionPercentage{
                    feedbackText.text.append(" Of the declensions that you just worked on you need to work on the first declension the most.")
                    
                }else if getSecondDeclensionPercentage < getFirstDeclensionPercentage && getSecondDeclensionPercentage < getThirdDeclensionPercentage && getSecondDeclensionPercentage < getFourthDeclensionPercentage && getSecondDeclensionPercentage < getFifthDeclensionPercentage{
                    feedbackText.text.append(" Of the declensions that you just worked on you need to work on the second declension the most.")
                    
                }else if getThirdDeclensionPercentage < getFirstDeclensionPercentage && getThirdDeclensionPercentage < getSecondDeclensionPercentage && getThirdDeclensionPercentage < getFourthDeclensionPercentage && getThirdDeclensionPercentage < getFifthDeclensionPercentage{
                    feedbackText.text.append(" Of the declensions that you just worked on you need to work on the third declension the most.")
                    
                }else if getFourthDeclensionPercentage < getFirstDeclensionPercentage && getFourthDeclensionPercentage < getSecondDeclensionPercentage  && getFourthDeclensionPercentage < getThirdDeclensionPercentage && getFourthDeclensionPercentage < getFifthDeclensionPercentage{
                    feedbackText.text.append(" Of the declensions that you just worked on you need to work on the fourth declension the most.")
                    
                }else if getFifthDeclensionPercentage < getFirstDeclensionPercentage && getFifthDeclensionPercentage < getSecondDeclensionPercentage  && getFifthDeclensionPercentage < getThirdDeclensionPercentage && getFifthDeclensionPercentage < getFourthDeclensionPercentage{
                    feedbackText.text.append(" Of the declensions that you just worked on you need to work on the fifth declension the most.")
                }
            } else {
                if firstDeclensionTotal > 0 && secondDeclensionTotal > 0{
                    if getFirstDeclensionPercentage > getSecondDeclensionPercentage{
                        feedbackText.text.append(" The second declension proved to be more difficult for you than the first declension.")
                    } else {
                        feedbackText.text.append(" The first declension proved to be more difficult for you than the second declension.")
                    }
                }
                if firstDeclensionTotal > 0 && thirdDeclensionTotal > 0{
                    if getFirstDeclensionPercentage > getThirdDeclensionPercentage{
                        feedbackText.text.append(" The third declension proved to be more difficult for you than the first declension.")
                    } else {
                        feedbackText.text.append(" The first declension proved to be more difficult for you than the third declension.")
                    }
                }
                if secondDeclensionTotal > 0 && thirdDeclensionTotal > 0{
                    if getSecondDeclensionPercentage > getThirdDeclensionPercentage{
                        feedbackText.text.append(" The third declension proved to be more difficult for you than the second declension.")
                    } else {
                        feedbackText.text.append(" The second declension proved to be more difficult for you than the third declension.")
                    }
                }
            }
        }
    }
    
    fileprivate func showDeclinablesControllerResults() {
        if navigationController == nil{
            loader = (presentingViewController! as! DeclinablesControllerDelegate)
        } else {
            loader = (navigationController!.viewControllers[navigationController!.viewControllers.count - 2] as! DeclinablesControllerDelegate)
        }
        
        resultsToGrade = loader!.questionList
        for noun in resultsToGrade{
            totalQuestions += 12
            if noun.declensionNumber == 1{
                firstDeclensionTotal += 12
            }else if noun.declensionNumber == 2{
                secondDeclensionTotal += 12
            } else {
                thirdDeclensionTotal += 12
            }
            
            //New scoring implementation
            if storage.bool(forKey: "scoreMacrons"){
                for item in 1...noun.correctAnswers.count{
                    if noun.correctAnswers[item - 1].lowercased() == noun.userAnswers[item - 1]?.lowercased(){
                        correctAnswers += 1
                    } else {
                        changeIncorrectAnswersWith(noun)
                    }
                }
            } else {
                for item in 1...noun.correctAnswers.count{
                    let correctAnswer = noun.correctAnswers[item - 1].lowercased()
                    let userAnswer = noun.userAnswers[item - 1]?.lowercased()
                    if correctAnswer.removeMacrons() == userAnswer?.removeMacrons(){
                        correctAnswers += 1
                    } else {
                        changeIncorrectAnswersWith(noun)
                    }
                }
            }
        }
        percentageScore = Int((Double(correctAnswers)/Double(totalQuestions)) * 100.0)
        generateFeedback()
    }
    
    fileprivate func showSingleQuestionModeResults() {
        print("SingleQuestionMode")
        
        singleQuestionForms = (presenter as! PracticeScreen).userPrompts
        singleQuestionAnswers = (presenter as! PracticeScreen).userAnswers
        resultsToGrade = (presenter as! PracticeScreen).questions
        
        let navigator = navigationController as! CustomWordNavigator
        navigator.questionList = resultsToGrade
        navigator.singleQuestionAnswers = singleQuestionAnswers
        navigator.singleQuestionForms = singleQuestionForms
        
        totalQuestions = 0
        
        for question in 0...resultsToGrade.count - 1{
            if singleQuestionAnswers[question] != nil{
                totalQuestions += 1
                
                switch resultsToGrade[question].correctRoot.2{
                case .first: firstDeclensionTotal += 1
                case .second: secondDeclensionTotal += 1
                case .third: thirdDeclensionTotal += 1
                case .secondNeuter: secondDeclensionTotal += 1
                case .thirdNeuter: thirdDeclensionTotal += 1
                case .fourth: fourthDeclensionTotal += 1
                case .fourthNeuter: fourthDeclensionTotal += 1
                case .fifth: fifthDeclensionTotal += 1
                }
                
                
                if singleQuestionForms[question].correctEnding(inDeclension: resultsToGrade[question].correctRoot.2) != "ORIGINAL"{
                
                    if singleQuestionAnswers[question]!.lowercased().hasSuffix(singleQuestionForms[question].correctEnding(inDeclension: resultsToGrade[question].correctRoot.2)){
                        correctAnswers += 1
                    }
                    
                }else if singleQuestionAnswers[question]!.lowercased() == resultsToGrade[question].correctRoot.0.lowercased(){
                    correctAnswers += 1
                }
            }
        }
        percentageScore = Int(100.0*(Double(correctAnswers)/(Double(resultsToGrade.count))))
        generateFeedback()
    }
    
    func changeIncorrectAnswersWith(_ noun: AnswerChecker){
        if noun.declensionNumber == 1{
            firstDeclensionIncorrect += 1
        }else if noun.declensionNumber == 2{
            secondDeclensionIncorrect += 1
        } else {
            thirdDeclensionIncorrect += 1
        }
    }
    
    @IBAction func compareAnswers(_ sender: UIButton) {
        
    }
}
