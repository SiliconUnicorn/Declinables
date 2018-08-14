//
//  MainMenu.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 1/26/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import UIKit
import DeclinablesLibrary
import Foundation
import WatchConnectivity

final class MainMenu: UIViewController{
    
    @IBOutlet weak var practiceDeclinablesButton: UIButton!
    @IBOutlet weak var practiceCustomWordButton: UIButton!
    @IBOutlet weak var reviewDeclensionsButton: UIButton!
    @IBOutlet weak var practiceSelectFormsButton: UIButton!
    @IBOutlet weak var savedWordsButton: UIButton!
    
    @IBOutlet weak var suggestedPracticeTitle: UILabel?
    @IBOutlet weak var suggestedPracticeText: UITextView?
    @IBOutlet weak var suggestedPracticeGlyph: UIImageView?
    
    let storage = UserDefaults()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ get{ return .lightContent}}
    
    let accessibleStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var suggestedPracticeDeclension = Declensions.first
    
    var firstDeclensionQuestions = [AnswerChecker("Puella", "Puellae")]
    var secondDeclensionQuestions = [AnswerChecker("Puella", "Puellae")]
    var thirdDeclensionQuestions = [AnswerChecker("Naves", "Navis")]
    var fourthDeclensionQuestions: [AnswerChecker] = []
    var fifthDeclensionQuestions: [AnswerChecker] = []
    
    var internalSuggestion = "DISABLED"
    
    let watch = WCSession.default
    
    ///`masterList` enables a complete, `String` represented, version of customized user words for usage in being transfered to a paired Watch
    var masterList: [String] = []
    
    ///`unexpectedlyLow` is a value specific for the Suggested for You feature. It will be used to decide if user scores are too low.
    let unexpectedlyLow = 0.25
    
    fileprivate func scoreBasedSuggestion(forDeclension declension : Declensions) {
        suggestedPracticeDeclension = declension
        suggestedPracticeTitle?.text? = declension.description + " Practice"
        suggestedPracticeGlyph?.image = UIImage(named: declension.description)
        
        suggestedPracticeText?.text = "Your \(declension.description.lowercased()) noun scores are significantly below your average. You should review and then practice your \(declension.description.lowercased()) nouns."
        
        if Double(storage.integer(forKey: "\(declension.lowerCamelDescription)Correct")) / Double(storage.integer(forKey: "\(declension.lowerCamelDescription)Total")) < unexpectedlyLow{
            suggestedPracticeDeclension = declension
            suggestedPracticeTitle?.text? = "Review \(declension.description)"
            suggestedPracticeGlyph?.image = UIImage(named: "Paper Glyph")
            storage.set("REVIEW: \(declension.description)", forKey: "SpecialSuggestion")
            
            suggestedPracticeText?.text = "Your \(declension.description.lowercased()) noun scores have been unexpectedly low. You should review your \(declension.description.lowercased()) nouns."
        }
    }
    
    
    
    fileprivate func suggestPracticeBasedOnTimesPracticed() {
        if storage.integer(forKey: "firstDeclensionTotal") < storage.integer(forKey: "secondDeclensionTotal") && storage.integer(forKey: "firstDeclensionTotal") < storage.integer(forKey: "thirdDeclensionTotal") && storage.integer(forKey: "firstDeclensionTotal") < storage.integer(forKey: "fourthDeclensionTotal") && storage.integer(forKey: "firstDeclensionTotal") < storage.integer(forKey: "fifthDeclensionTotal"){
            suggestedPracticeDeclension = .first
            suggestedPracticeTitle?.text? = "First Declension Practice"
            suggestedPracticeGlyph?.image = UIImage(named: "First Declension")
        }
        
        if storage.integer(forKey: "secondDeclensionTotal") < storage.integer(forKey: "firstDeclensionTotal") && storage.integer(forKey: "secondDeclensionTotal") < storage.integer(forKey: "thirdDeclensionTotal") && storage.integer(forKey: "secondDeclensionTotal") < storage.integer(forKey: "fourthDeclensionTotal") && storage.integer(forKey: "secondDeclensionTotal") < storage.integer(forKey: "fifthDeclensionTotal"){
            suggestedPracticeDeclension = .second
            suggestedPracticeTitle?.text? = "Second Declension Practice"
            suggestedPracticeGlyph?.image = UIImage(named: "Second Declension")
        }
        
        if storage.integer(forKey: "thirdDeclensionTotal") < storage.integer(forKey: "secondDeclensionTotal") && storage.integer(forKey: "thirdDeclensionTotal") < storage.integer(forKey: "firstDeclensionTotal") && storage.integer(forKey: "thirdDeclensionTotal") < storage.integer(forKey: "fourthDeclensionTotal") && storage.integer(forKey: "thirdDeclensionTotal") < storage.integer(forKey: "fifthDeclensionTotal"){
            suggestedPracticeDeclension = .third
            suggestedPracticeTitle?.text? = "Third Declension Practice"
            suggestedPracticeGlyph?.image = UIImage(named: "Third Declension")
        }
        
        if storage.integer(forKey: "fourthDeclensionTotal") < storage.integer(forKey: "firstDeclensionTotal") && storage.integer(forKey: "fourthDeclensionTotal") < storage.integer(forKey: "secondDeclensionTotal") && storage.integer(forKey: "fourthDeclensionTotal") < storage.integer(forKey: "thirdDeclensionTotal") && storage.integer(forKey: "fourthDeclensionTotal") < storage.integer(forKey: "fifthDeclensionTotal"){
            suggestedPracticeDeclension = .fourth
            suggestedPracticeTitle?.text? = "Fourth Declension Practice"
            suggestedPracticeGlyph?.image = UIImage(named: "Fourth Declension")
        }
        
        if storage.integer(forKey: "fifthDeclensionTotal") < storage.integer(forKey: "firstDeclensionTotal") && storage.integer(forKey: "fifthDeclensionTotal") < storage.integer(forKey: "secondDeclensionTotal") && storage.integer(forKey: "fifthDeclensionTotal") < storage.integer(forKey: "thirdDeclensionTotal") && storage.integer(forKey: "fifthDeclensionTotal") < storage.integer(forKey: "fourthDeclensionTotal"){
            suggestedPracticeDeclension = .fifth
            suggestedPracticeTitle?.text? = "Fifth Declension Practice"
            suggestedPracticeGlyph?.image = UIImage(named: "Fifth Declension")
        }
    }
    
    func addUserDefinedWords() {
        let userQuestions = storage.array(forKey: "userQuestions")
        
        if !(userQuestions == nil) && !((userQuestions as! [String]).contains("Error, Erroris (E)")){
            for item in storage.array(forKey: "userQuestions") as! [String]{
                let newAnswerChecker = AnswerChecker(item)
                switch newAnswerChecker.declensionNumber{
                case 1: firstDeclensionQuestions.append(newAnswerChecker)
                case 2: secondDeclensionQuestions.append(newAnswerChecker)
                case 3: thirdDeclensionQuestions.append(newAnswerChecker)
                case 4: fourthDeclensionQuestions.append(newAnswerChecker)
                case 5: fifthDeclensionQuestions.append(newAnswerChecker)
                default: fatalError("NO SUCH DECLENSION: Declension Number \(newAnswerChecker.declensionNumber) Does Not Exist")
                }
            }
        }
        
        addWordsToWatch()
    }
    
    func addWordsToWatch(){
        if WCSession.isSupported(){
            
            if watch.isPaired && watch.isWatchAppInstalled{
                
                if masterList.count > 1{
                    var context: [String : String] = [:]
                    context.removeAll()
                    for word in masterList{
                        context.updateValue(word, forKey: word)
                    }
                    try! watch.updateApplicationContext(context)
                }
            }
        }
    }
    
    func setDefaultWords() {
        firstDeclensionQuestions = [AnswerChecker("Puella", "Puellae"), AnswerChecker("Aqua", "Aquae"), AnswerChecker("Causa", "Causae"), AnswerChecker("Ara", "Arae"), AnswerChecker("Epistola", "Epistolae"), AnswerChecker("Femina", "Feminae"), AnswerChecker("Tunica", "Tunicae"), AnswerChecker("Vita", "Vitae"), AnswerChecker("Fenestra", "Fenestrae"), AnswerChecker("Persona", "Personae"), AnswerChecker("Porta", "Portae"), AnswerChecker("Simia", "Simiae"), AnswerChecker("Umbra", "Umbrae"), AnswerChecker("Panthera", "Pantherae")]
        
        secondDeclensionQuestions = [AnswerChecker("Equus", "Equi"), AnswerChecker("Factus", "Facti"), AnswerChecker("Cibus", "Cibi"), AnswerChecker("Populus", "Populi"), AnswerChecker("Animus", "Animi"), AnswerChecker("Murus", "Muri"), AnswerChecker("Caseus", "Casei"), AnswerChecker("Curriculum", "Curriculi"), AnswerChecker("Tintinnabulum", "Tintinnabuli"), AnswerChecker("Leapardus", "Leapardi")]
        
        thirdDeclensionQuestions = [AnswerChecker("Rex", "Regis"), AnswerChecker("Pons", "Pontis"), AnswerChecker("Serpens", "Serpentis"), AnswerChecker("Tempestas", "Tempestis"), AnswerChecker("Vestis", "Vestis"), AnswerChecker("Amor", "Amoris"), AnswerChecker("Caput", "Capitis"), AnswerChecker("Custos", "Custodis"), AnswerChecker("Soror", "Sororis"), AnswerChecker("Frater", "Fratris"), AnswerChecker("Mater", "Matris"), AnswerChecker("Pater", "Patris"), AnswerChecker("Fulmen", "Fulminis"), AnswerChecker("Pecus", "Pecoris")]
        
        fourthDeclensionQuestions = [AnswerChecker("Actus", "Actus"), AnswerChecker("Artus", "Artus"), AnswerChecker("Captus", "Captus"), AnswerChecker("Dilectus", "Dilectus"), AnswerChecker("Effectus", "Effectus"), AnswerChecker("Vestitus", "Vestitus"), AnswerChecker("Manus", "Manus"), AnswerChecker(identical: "Cursus"), AnswerChecker(identical: "Domus"), AnswerChecker(identical: "Arcus"), AnswerChecker(identical: "Principatus"), AnswerChecker(identical: "Crūciatus"), AnswerChecker("Cornu", "Cornus"), AnswerChecker("Genu", "Genus")]
        
        fifthDeclensionQuestions = [AnswerChecker("Res", "Rei"), AnswerChecker("Spes", "Spei"), AnswerChecker("Dies", "Diei"), AnswerChecker("Fides", "Fidei"), AnswerChecker("Acies", "Acicei"), AnswerChecker("Facies", "Faciei"), AnswerChecker("Effigies", "Effigei"), AnswerChecker("Glacies", "Glacei"), AnswerChecker("Eluvies", "Eluvei"), AnswerChecker("Series", "Serei")]
    }
    
    fileprivate func iPhoneInterfaceChanges() {
        //The implementation for iPhone
        //Buttons change positioning of text
        savedWordsButton.contentHorizontalAlignment = .left
        reviewDeclensionsButton.contentHorizontalAlignment = .left
        practiceCustomWordButton.contentHorizontalAlignment = .left
        practiceDeclinablesButton.contentHorizontalAlignment = .left
        practiceSelectFormsButton.contentHorizontalAlignment = .left
    }
    
    fileprivate func standardSuggestionGeneration() {
        
        setSuggestionRandomly()
        
        if Double(storage.integer(forKey: "firstDeclensionCorrect")) / Double(storage.integer(forKey: "firstDeclensionTotal")) <= Double(storage.integer(forKey: "totalCorrect")) / Double(storage.integer(forKey: "totalQuestions")) - 0.1{
            scoreBasedSuggestion(forDeclension: .first)
        }
            
        else if Double(storage.integer(forKey: "secondDeclensionCorrect")) / Double(storage.integer(forKey: "secondDeclensionTotal")) <= Double(storage.integer(forKey: "totalCorrect")) / Double(storage.integer(forKey: "totalQuestions")) - 0.1{
            scoreBasedSuggestion(forDeclension: .second)
        }
            
        else if Double(storage.integer(forKey: "thirdDeclensionCorrect")) / Double(storage.integer(forKey: "thirdDeclensionTotal")) <= Double(storage.integer(forKey: "totalCorrect")) / Double(storage.integer(forKey: "totalQuestions")) - 0.1{
            scoreBasedSuggestion(forDeclension: .third)
            
        }else if Double(storage.integer(forKey: "secondDeclensionCorrect")) / Double(storage.integer(forKey: "secondDeclensionTotal")) <= Double(storage.integer(forKey: "totalCorrect")) / Double(storage.integer(forKey: "totalQuestions")) - 0.1{
            scoreBasedSuggestion(forDeclension: .fourth)
            
        }else if Double(storage.integer(forKey: "secondDeclensionCorrect")) / Double(storage.integer(forKey: "secondDeclensionTotal")) <= Double(storage.integer(forKey: "totalCorrect")) / Double(storage.integer(forKey: "totalQuestions")) - 0.1{
            scoreBasedSuggestion(forDeclension: .fifth)
            
        } else {
            suggestPracticeBasedOnTimesPracticed()
            
            suggestedPracticeText?.text = "You've been practicing your " + suggestedPracticeDeclension.description.lowercased() + " nouns less than you've been practicing the others. You should consider practicing your " + suggestedPracticeDeclension.description.lowercased() + " nouns."
        }
    }
    
    fileprivate func iPadInterfaceChanges() {
        // Prepares the iPad-only Suggested for You feature to work.
        
        //The first step is to disable any special instructions that may be active.
        storage.set("DISABLED", forKey: "SpecialSuggestion")
        
        if storage.bool(forKey: "noPracticesSinceLaunch") == true{
            if storage.bool(forKey: "iPad_hideWelcome") != true{
                showPretestAsSuggested()
            }
        } else {
            standardSuggestionGeneration()
        }
        
        internalSuggestion = storage.string(forKey: "SpecialSuggestion")!
    }
    
    fileprivate func deviceSpecificLoading() {
        if UIDevice.current.model == "iPad"{
            iPadInterfaceChanges()
        } else {
            iPhoneInterfaceChanges()
        }
    }
    
    func saveWordsToNavigator(_ navigator: CustomWordNavigator) {
        navigator.firstDeclensionQuestions = firstDeclensionQuestions
        navigator.secondDeclensionQuestions = secondDeclensionQuestions
        navigator.thirdDeclensionQuestions = thirdDeclensionQuestions
        navigator.fourthDeclensionQuestions = fourthDeclensionQuestions
        navigator.fifthDeclensionQuestions = fifthDeclensionQuestions
        
        navigator.scoreEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Resets words.
        setDefaultWords()
        addUserDefinedWords()
        
        deviceSpecificLoading()
        saveWordsToNavigator(navigationController as! CustomWordNavigator)
        preventErrors()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if WCSession.isSupported(){
            watch.delegate = self
            watch.activate()
        }
    }
    
    fileprivate func preventErrors(){
        (navigationController! as! CustomWordNavigator).testType = .singleQuestionMode
        var questions = firstDeclensionQuestions + secondDeclensionQuestions + thirdDeclensionQuestions + fourthDeclensionQuestions + fifthDeclensionQuestions
        while questions.count > 5{
            questions.remove(at: Dice().rollD(questions.count) - 1)
        }
        (navigationController! as! CustomWordNavigator).questionList = questions
        (navigationController! as! CustomWordNavigator).setupQuestionTotal = questions.count
    }
    
    func setSuggestionRandomly(){
        let random = Dice().rollD(5)
        switch random{
        case 1: suggestedPracticeDeclension = .first; suggestedPracticeTitle?.text? = "First Declension Practice"; suggestedPracticeGlyph?.image = UIImage(named: "First Declension")
        case 2: suggestedPracticeDeclension = .second; suggestedPracticeTitle?.text? = "Second Declension Practice"; suggestedPracticeGlyph?.image = UIImage(named: "Second Declension")
        case 3: suggestedPracticeDeclension = .third; suggestedPracticeTitle?.text? = "Third Declension Practice"; suggestedPracticeGlyph?.image = UIImage(named: "Third Declension")
        case 4: suggestedPracticeDeclension = .fourth; suggestedPracticeTitle?.text? = "Fourth Declension Practice"; suggestedPracticeGlyph?.image = UIImage(named: "Fourth Declension")
        case 5: suggestedPracticeDeclension = .fifth; suggestedPracticeTitle?.text? = "Fifth Declension Practice"; suggestedPracticeGlyph?.image = UIImage(named: "Fifth Declension")
        default: print("ERROR")
        }
        
        suggestedPracticeText?.text = "You should practice declining your " + suggestedPracticeDeclension.description.lowercased() + " nouns."
    }
    
    func allowOnly(_ declension: Declensions){
        switch declension{
        case .first: (navigationController as! CustomWordNavigator).questionList = firstDeclensionQuestions
        case .second: (navigationController as! CustomWordNavigator).questionList = secondDeclensionQuestions
        case .third: (navigationController as! CustomWordNavigator).questionList = thirdDeclensionQuestions
        case .fourth: (navigationController as! CustomWordNavigator).questionList = fourthDeclensionQuestions
        case .fifth: (navigationController as! CustomWordNavigator).questionList = fifthDeclensionQuestions
        default: print("ERROR: Neuter is not supported for this method yet.")
        }
        
        while (navigationController as! CustomWordNavigator).questionList.count > 5{
            (navigationController as! CustomWordNavigator).questionList.remove(at: Dice().rollD((navigationController as! CustomWordNavigator).questionList.count) - 1)
        }
    }
    
    func showPretestAsSuggested(){
        suggestedPracticeTitle?.text? = "Take a Pretest"
        suggestedPracticeGlyph?.image = UIImage(named: "A+")
        suggestedPracticeText?.text = "Welcome to Declinables, an app designed to help you practice and improve your ability to decline Latin nouns. We highly suggest that you take a quick pretest so that we can suggest the most relevant possible practices to you."
    }
    
    @IBAction func loadSuggestedPractice(_ sender: UIButton) {
        storage.set(false, forKey: "noPracticesSinceLaunch")
        (navigationController as! CustomWordNavigator).testType = .singleQuestionMode
        
        if suggestedPracticeTitle?.text == "Take a Pretest"{
            (navigationController as! CustomWordNavigator).testType = .singleQuestionMode
            (navigationController as! CustomWordNavigator).questionList = [AnswerChecker("Puella", "Puellae"), AnswerChecker("Murus", "Muri"), AnswerChecker("Rex", "Regis")]
            
            //Makes sure that this doesn't appear again after it is used for the first time.
            storage.set(true, forKey: "iPad_hideWelcome")
            navigationController?.pushViewController(storyboard!.instantiateViewController(withIdentifier: "NewPractice"), animated: true)
        }else if storage.string(forKey: "SpecialSuggestion") != "DISABLED" && storage.string(forKey: "SpecialSuggestion") != nil{
            let suggestion = storage.string(forKey: "SpecialSuggestion")
            if suggestion!.hasPrefix("REVIEW: "){
                if suggestion!.hasSuffix("First"){
                    present((accessibleStoryboard.instantiateViewController(withIdentifier: "NewDeclensionChart")), animated: true, completion: nil)
                }else if suggestion!.hasSuffix("Second"){
                    present((accessibleStoryboard.instantiateViewController(withIdentifier: "NewDeclensionChart")), animated: true, completion: nil)
                }else if suggestion!.hasSuffix("Third"){
                    present((accessibleStoryboard.instantiateViewController(withIdentifier: "NewDeclensionChart")), animated: true, completion: nil)
                }else if suggestion!.hasSuffix("Fourth"){
                present((accessibleStoryboard.instantiateViewController(withIdentifier: "NewDeclensionsChart")), animated: true, completion: nil)
                }else if suggestion!.hasSuffix("Fifth"){
            present((accessibleStoryboard.instantiateViewController(withIdentifier: "NewDeclensionsChart")), animated: true, completion: nil)
                }
            }
        } else {
            allowOnly(suggestedPracticeDeclension)
            navigationController!.pushViewController(storyboard!.instantiateViewController(withIdentifier: "NewPractice"), animated: true)
        }
    }
    @IBAction func prepareToAcceptSuggestion(_ sender: UIButton) {
        storage.set(internalSuggestion, forKey: "SpecialSuggestion")
        
    }
    
    @IBAction func returnToPractice(_ sender: UIButton) {
        storage.set(false, forKey: "noPracticesSinceLaunch")
    }
    
    @IBAction func reviewDeclensions(_ sender: UIButton) {
        storage.set(false, forKey: "noPracticesSinceLaunch")
    }
    
    @IBAction func prepareToReview(_ sender: UIButton) {
        storage.set("DISABLED", forKey: "SpecialSuggestion")
    }
    
    @IBAction func useCustomWord(_ sender: UIButton) {
        storage.set(false, forKey: "noPracticesSinceLaunch")
    }
    
    @IBAction func openSingleQuestionMode(_ sender: UIButton) {
        storage.set(false, forKey: "noPracticesSinceLaunch")
        (navigationController! as! CustomWordNavigator).testType = .singleQuestionMode
        var questions = firstDeclensionQuestions + secondDeclensionQuestions + thirdDeclensionQuestions + fourthDeclensionQuestions + fifthDeclensionQuestions
        while questions.count > 5{
            questions.remove(at: Dice().rollD(questions.count) - 1)
        }
        (navigationController! as! CustomWordNavigator).questionList = questions
        (navigationController! as! CustomWordNavigator).setupQuestionTotal = questions.count
    }
    @IBAction func showSavedWords(_ sender: UIButton) {
        storage.set(false, forKey: "noPracticesSinceLaunch")
    }
}

@available(iOS 9.3, *) extension MainMenu: WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Sending Data")
        if WCSession.isSupported(){
            if watch.isPaired && watch.isWatchAppInstalled{
                if masterList.count > 1{
                    var context: [String : String] = [:]
                    context.removeAll()
                    for word in masterList{
                        context.updateValue(word, forKey: word)
                    }
                    try! watch.updateApplicationContext(context)
                }
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
