//
//  PracticeScreen.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 2/26/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit
import DeclinablesLibrary

final class PracticeScreen: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, DeclinablesControllerDelegate{
    var setupQuestionTotal = 0
    
    var questionList: [AnswerChecker]{ get{ return questions} set(newVersion){questions = newVersion}}
    
    var firstDeclensionQuestions: [AnswerChecker] = []
    
    var secondDeclensionQuestions: [AnswerChecker] = []
    
    var thirdDeclensionQuestions: [AnswerChecker] = []
    
    var fourthDeclensionQuestions: [AnswerChecker] = []
    
    var fifthDeclensionQuestions: [AnswerChecker] = []
    
    var firstDeclensionEnabled = false
    
    var secondDeclensionEnabled = false
    
    var thirdDeclensionEnabled = false
    
    var scoreEnabled = true
    
    var currentQuestion = 0
    var totalQuestions: Int{ get{ return questions.count}}
    var questions: [AnswerChecker] = []
    var previouslyLoaded = false
    
    var userAnswers: [String] = []
    var userPrompts: [PossibleDeclensions] = []
    
    var testType = TestTypes.declinablesController
    
    var currentController: UIViewController? = nil
    
    var allowShowing = true
    
    @IBOutlet weak var pageDots: UIPageControl!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    var memberNumber = 0{ didSet{
        print(memberNumber)
        if memberNumber == 0{
            backButton.isEnabled = false
        } else {
            backButton.isEnabled = true
        }
        if memberNumber >= questions.count{
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        }}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if previouslyLoaded{
            navigationController!.popViewController(animated: true)
        } else {
            if let initLoader = navigationController{
                let loader = (initLoader as! CustomWordNavigator)
                questions = loader.questionList
                setupQuestionTotal = questions.count
                testType = loader.testType
                previouslyLoaded = true
                scoreEnabled = loader.scoreEnabled
            } else {
                let loader = (presentingViewController as! DeclinablesControllerDelegate)
                questions = loader.questionList
                setupQuestionTotal = questions.count
                testType = loader.testType
                scoreEnabled = loader.scoreEnabled
            }
            
            (childViewControllers[0] as! UIPageViewController).dataSource = self
            (childViewControllers[0] as! UIPageViewController).delegate = self
            
            pageDots.numberOfPages = questions.count + 1
            
            switch testType{
            case .declinablesController: do{
                let replacementController = storyboard!.instantiateViewController(withIdentifier: "PracticeHeading") as! PracticeHeading
                replacementController.viewControllerNoun = questions[memberNumber]
                (childViewControllers[0] as! UIPageViewController).setViewControllers([replacementController], direction: .forward, animated: true, completion: nil)
                
                currentController = replacementController
                }
            case .singleQuestionMode: do{
                let replacementController = storyboard!.instantiateViewController(withIdentifier: "QuickPractice") as! QuickPractice
                for _ in questions{
                    userAnswers.append("")
                    userPrompts.append(PossibleDeclensions.init(from: Dice().d12 - 1)!)
                }
                replacementController.key = questions[memberNumber]
                replacementController.correctTitle = userPrompts[memberNumber].description
                (childViewControllers[0] as! UIPageViewController).setViewControllers([replacementController], direction: .forward, animated: true, completion: nil)
                
                currentController = replacementController
                }
            }
        }
    }
    
    fileprivate func getDeclinablesController(forNumber memberNumber: Int) -> PracticeHeading{
        let newController = storyboard?.instantiateViewController(withIdentifier: "PracticeHeading") as! PracticeHeading
        newController.viewControllerNoun = questions[memberNumber]
        return newController
    }
    
    fileprivate func getQuickPractice(forNumber memberNumber: Int) -> QuickPractice{
        let newController = storyboard?.instantiateViewController(withIdentifier: "QuickPractice") as! QuickPractice
        newController.key = questions[memberNumber]
        newController.correctTitle = userPrompts[memberNumber].description
        newController.userInput = userAnswers[memberNumber]
        return newController
    }
    
    fileprivate func getController(forNumber memberNumber: Int, andTest testType: TestTypes) -> UIViewController?{
        if memberNumber < 0{
            return nil
        }else if memberNumber > questions.count - 1{
            return storyboard?.instantiateViewController(withIdentifier: "EndPractice")
        } else {
            var returningController: UIViewController? = nil
            switch testType{
            case .declinablesController: returningController = getDeclinablesController(forNumber: memberNumber)
            case .singleQuestionMode: returningController = getQuickPractice(forNumber: memberNumber)
            }
            return returningController!
        }
    }
    
    fileprivate func saveQuickPracticeController(controller: QuickPractice, forNumber memberNumber: Int){
        controller.saveUserInput()
        userAnswers[memberNumber] = controller.userInput
    }
    
    fileprivate func savePracticeHeading(controller: PracticeHeading, forNumber memberNumber: Int){
        controller.saveUserInput()
        questions[memberNumber] = controller.viewControllerNoun
    }
    
    fileprivate func saveController(controller: UIViewController, forNumber memberNumber: Int, andTest testType: TestTypes){
        guard !(controller is EndPractice) else{
            for question in questions{
                switch question.declensionNumber{
                case 1: firstDeclensionQuestions.append(question)
                case 2: secondDeclensionQuestions.append(question)
                case 3: thirdDeclensionQuestions.append(question)
                case 4: fourthDeclensionQuestions.append(question)
                case 5: fifthDeclensionQuestions.append(question)
                default: fatalError("Declension Number \(question.declensionNumber) Is Not Valid")
                }
            }
            return
        }
        //self.memberNumber = findMemberNumber(forController: controller)
        switch testType{
        case .declinablesController: savePracticeHeading(controller: controller as! PracticeHeading, forNumber: memberNumber)
        case .singleQuestionMode: saveQuickPracticeController(controller: controller as! QuickPractice, forNumber: memberNumber)
        }
    }
    
    func findMemberNumber(forController currentController: UIViewController) -> Int{
        if currentController is PracticeHeading{
            return questions.index(of: (currentController as! PracticeHeading).viewControllerNoun)!
        }else if currentController is QuickPractice{
            return questions.index(of: (currentController as! QuickPractice).key!)!
        } else {
            return questions.count
        }
    }
    
    fileprivate func getViewController(incrementedFrom viewController: UIViewController, byAmount incrementer: Int) -> UIViewController?{
        var temporaryMemberNumber = findMemberNumber(forController: viewController)
        saveController(controller: viewController, forNumber: temporaryMemberNumber, andTest: testType)
        temporaryMemberNumber = findMemberNumber(forController: viewController) + incrementer
        return getController(forNumber: temporaryMemberNumber, andTest: testType)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getViewController(incrementedFrom: viewController, byAmount: -1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getViewController(incrementedFrom: viewController, byAmount: 1)
    }
    
    @IBAction func pageDotsChanged(_ sender: UIPageControl) {
        memberNumber = findMemberNumber(forController: currentController!)
        if pageDots.currentPage < memberNumber{
            (childViewControllers[0] as! UIPageViewController).setViewControllers([getViewController(incrementedFrom: currentController!, byAmount: -1)!], direction: .reverse, animated: true, completion: nil)
        } else {
            (childViewControllers[0] as! UIPageViewController).setViewControllers([getViewController(incrementedFrom: currentController!, byAmount: 1)!], direction: .forward, animated: true, completion: nil)
        }
    }
    @IBAction func previousPage(_ sender: UIButton) {
        guard memberNumber >= 0 else{
            print("Error: Back button should not be enabled")
            return
        }
        let replacement = getViewController(incrementedFrom: currentController!, byAmount: -1)!
        (childViewControllers[0] as! UIPageViewController).setViewControllers([replacement], direction: .reverse, animated: true, completion: nil)
    }
    
    @IBAction func nextPage(_ sender: UIButton) {
        (childViewControllers[0] as! UIPageViewController).setViewControllers([getViewController(incrementedFrom: currentController!, byAmount: 1)!], direction: .forward, animated: true, completion: nil)
    }
}
