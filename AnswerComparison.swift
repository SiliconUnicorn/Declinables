//
//  AnswerComparison.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 3/26/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit
import DeclinablesLibrary

final class AnswerComparison: UIViewController{
    weak var setupController: CustomWordNavigator? = nil
    
    weak var currentPage: UIViewController? = nil
    
    @IBOutlet weak var pageDots: UIPageControl!
    
    var testType = TestTypes.declinablesController
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var questionNumberTotal = 1
    var currentQuestion = 1{
        didSet{
            if currentQuestion <= 0{
                backButton.isEnabled = false
            } else {
                backButton.isEnabled = true
            }
            
            if currentQuestion >= questionNumberTotal - 1{
                nextButton.isEnabled = false
            } else {
                nextButton.isEnabled = true
            }
        }
    }
    
    @IBOutlet weak var latinRootTitle: UILabel!
    
    var buttonsList: [ButtonComparer] = [ButtonComparer()]
    
    var answerKey: [AnswerChecker] = []
    
    weak var pageViewController: UIPageViewController? = nil
    
    var formList:  [PossibleDeclensions] = []
    var answerList: [String?] = [nil]
    
    override func viewWillAppear(_ animated: Bool) {
        loadBasicInformation()
        preparePageController()
        (presentingViewController as! CustomWordNavigator).hiddenStatusStyle = .default
        (presentingViewController as! CustomWordNavigator).setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        preparePageController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        (presentingViewController as! CustomWordNavigator).hiddenStatusStyle = .lightContent
        (presentingViewController as! CustomWordNavigator).setNeedsStatusBarAppearanceUpdate()
    }
    
    fileprivate func loadBasicInformation() {
        setupController = (presentingViewController as! CustomWordNavigator)
        answerKey = setupController!.questionList
        questionNumberTotal = setupController!.setupQuestionTotal
        testType = setupController!.testType
        pageDots.numberOfPages = questionNumberTotal
    }
    
    fileprivate func prepareStandardComparison() {
        let firstController = storyboard!.instantiateViewController(withIdentifier: "StandardComparisonPage") as! StandardComparisonPage
        firstController.answerKey = answerKey[0]
        pageViewController!.setViewControllers([firstController], direction: .forward, animated: false, completion: nil)
    }
    
    fileprivate func prepareQuickComparison() {
        formList = setupController!.singleQuestionForms
        answerList = setupController!.singleQuestionAnswers
        
        latinRootTitle.text = "Quick Practice Comparison"
        
        let firstController = storyboard!.instantiateViewController(withIdentifier: "QuickComparisonPage") as! QuickComparisonPage
        
        firstController.currentQuestion = 0
        firstController.form = formList[0]
        firstController.userAnswerText = answerList[0]!
        firstController.answerKey = answerKey[0]
        
        pageViewController!.setViewControllers([firstController], direction: .forward, animated: false, completion: nil)
    }
    
    fileprivate func preparePageController() {
        pageViewController = (childViewControllers[0] as! UIPageViewController)
        pageViewController!.dataSource = self
        
        if testType == .declinablesController{
            prepareStandardComparison()
        } else {
            prepareQuickComparison()
        }
    }
    
    fileprivate func getStandardPage(forNumber memberNumber: Int) -> StandardComparisonPage{
        let returningController = storyboard?.instantiateViewController(withIdentifier: "StandardComparisonPage") as! StandardComparisonPage
        returningController.answerKey = answerKey[memberNumber]
        returningController.questionNumber = memberNumber
        return returningController
    }
    
    fileprivate func getQuickPage(forNumber memberNumber: Int) -> QuickComparisonPage{
        let returningController = storyboard?.instantiateViewController(withIdentifier: "QuickComparisonPage") as! QuickComparisonPage
        returningController.currentQuestion = memberNumber
        returningController.form = formList[memberNumber]
        returningController.userAnswerText = answerList[memberNumber]!
        returningController.answerKey = answerKey[memberNumber]
        return returningController
    }
    
    fileprivate func getViewController(forNumber memberNumber: Int) -> UIViewController{
        switch testType{
        case .declinablesController: return getStandardPage(forNumber: memberNumber)
        case .singleQuestionMode: return getQuickPage(forNumber: memberNumber)
        }
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        if sender.currentPage < currentQuestion{
            pageViewController!.setViewControllers([getViewController(forNumber: sender.currentPage)], direction: .reverse, animated: true, completion: nil)
        } else {
            pageViewController!.setViewControllers([getViewController(forNumber: sender.currentPage)], direction: .forward, animated: true, completion: nil)
        }
    }
    
    @IBAction func userRequestedDismissal(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(_ button: UIButton){
        if currentQuestion + 1 < questionNumberTotal{
            pageViewController!.setViewControllers([getViewController(forNumber: currentQuestion + 1)], direction: .forward, animated: true, completion: nil)
        } else {
            button.isEnabled = false
        }
    }
    
    @IBAction func backButtonTapped(_ button: UIButton){
        if currentQuestion - 1 > -1{
            pageViewController!.setViewControllers([getViewController(forNumber: currentQuestion - 1)], direction: .reverse, animated: true, completion: nil)
        } else {
            button.isEnabled = false
        }
    }
}

extension AnswerComparison: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if currentQuestion + 1 < questionNumberTotal{
            return getViewController(forNumber: currentQuestion + 1)
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if currentQuestion - 1 > -1{
            return getViewController(forNumber: currentQuestion - 1)
        } else {
            return nil
        }
    }
}
