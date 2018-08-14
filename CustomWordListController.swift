//
//  CustomWordListController.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 2/7/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit
import DeclinablesLibrary

final class CustomWordListController: UITableViewController, DeclinablesControllerDelegate, UISearchBarDelegate{
    
    var setupQuestionTotal = 1
    
    var questionList = [AnswerChecker("Puella", "Puellae")]
    
    var firstDeclensionQuestions = [AnswerChecker("Puella", "Puellae")]
    
    var secondDeclensionQuestions = [AnswerChecker("Puella", "Puellae")]
    
    var thirdDeclensionQuestions = [AnswerChecker("Puella", "Puellae")]
    
    var fourthDeclensionQuestions: [AnswerChecker] = []
    
    var fifthDeclensionQuestions: [AnswerChecker] = []
    
    var firstDeclensionEnabled = false
    
    var secondDeclensionEnabled = false
    
    var thirdDeclensionEnabled = false
    
    var testType = TestTypes.declinablesController
    
    var scoreEnabled = true
    
    var isSearching = false
    
    var selectedWord = AnswerChecker("Puella", "Puellae")
    
    var thirdGenders: [Bool] =  []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //The button to use to start a practice.
    @IBOutlet weak var launchIcon: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    ///Allows usage of the UserDefaults
    let storage = UserDefaults()
    
    ///This variable allows the app to decide how many sections of the TableView should be available to the user.
    var declensionsInUse = 0
    
    var firstDeclensionWords = [AnswerChecker("Puella", "Puellae")]
    var secondDeclensionWords = [AnswerChecker("Puella", "Puellae")]
    var thirdDeclensionWords = [AnswerChecker("Puella", "Puellae")]
    var fourthDeclensionWords = [AnswerChecker("Puella", "Puellae")]
    var fifthDeclensionWords = [AnswerChecker("Puella", "Puellae")]
    
    var searchWords = [AnswerChecker("Puella", "Puellae")]
    
    //Prevents incorrect titles from being shown to the user.
    var shouldShowFirst = false
    var shouldShowSecond = false
    var shouldShowThird = false
    var shouldShowFourth = false
    var shouldShowFifth = false
    
    func disableButtons(){
        launchIcon.isEnabled = false
        shareButton.isEnabled = false
    }
    
    func enableButtons(){
        launchIcon.isEnabled = true
        shareButton.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disableButtons()
        searchBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *){
            //Set delegation
            tableView.dragDelegate = self
            tableView.dropDelegate = self
        }
    }
    
    fileprivate func countUsedDeclensions() -> Int{
        var declensionsInUse = 0
        if firstDeclensionWords.count > 0{
            declensionsInUse += 1
            shouldShowFirst = true
        }
        if secondDeclensionWords.count > 0{
            declensionsInUse += 1
            shouldShowSecond = true
        }
        if thirdDeclensionWords.count > 0{
            declensionsInUse += 1
            shouldShowThird = true
        }
        if fourthDeclensionWords.count > 0{
            declensionsInUse += 1
            shouldShowFourth = true
        }
        if fifthDeclensionWords.count > 0{
            declensionsInUse += 1
            shouldShowFifth = true
        }
        return declensionsInUse
    }
    
    fileprivate func prepareWords() {
        firstDeclensionWords.removeAll()
        secondDeclensionWords.removeAll()
        thirdDeclensionWords.removeAll()
        fourthDeclensionWords.removeAll()
        fifthDeclensionWords.removeAll()
        
        declensionsInUse = 0
        
        let userQuestions = storage.array(forKey: "userQuestions")
        
        if !(userQuestions == nil) && !((userQuestions as! [String]).contains("Error, Erroris (E)")){
            var improvedUserQuestions = storage.array(forKey: "userQuestions") as! [String]
            if storage.bool(forKey: "alphabetize"){
                improvedUserQuestions.sort()
            }
            for item in improvedUserQuestions{
                let newAnswerChecker = AnswerChecker(item)
                switch newAnswerChecker.declensionNumber{
                case 1: firstDeclensionWords.append(newAnswerChecker)
                case 2: secondDeclensionWords.append(newAnswerChecker)
                case 3: thirdDeclensionWords.append(newAnswerChecker)
                case 4: fourthDeclensionWords.append(newAnswerChecker)
                case 5: fifthDeclensionWords.append(newAnswerChecker)
                default: fatalError("NO SUCH DECLENSION: Declension Number \(newAnswerChecker.declensionNumber) Does Not Exist")
                }
            }
        }
        
        declensionsInUse = countUsedDeclensions()
    }
    
    fileprivate func standardInitalization() {
        firstDeclensionWords.removeAll()
        secondDeclensionWords.removeAll()
        thirdDeclensionWords.removeAll()
        
        firstDeclensionQuestions.removeAll()
        secondDeclensionQuestions.removeAll()
        thirdDeclensionQuestions.removeAll()
        
        questionList.removeAll()
        
        prepareWords()
    }
    
    fileprivate func tableViewSetup() {
        tableView!.register(DeclensionCell.self, forCellReuseIdentifier: "DeclensionCell")
        tableView!.reloadData()
    }
    
    override init(style: UITableViewStyle) {
        
        super.init(style: style)
        
        standardInitalization()
        //tableViewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        standardInitalization()
        //tableViewSetup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        standardInitalization()
        //tableViewSetup()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching{
            return 1
        } else {
            return declensionsInUse
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = DeclensionCell()
        if isSearching{
            cell.textLabel?.text = searchWords[indexPath.item].displayName
        } else {
            
            actions(section: indexPath.section, firstDeclension: {
                cell.textLabel?.text = firstDeclensionWords[indexPath.item].displayName
            }, secondDeclension: {
                cell.textLabel?.text = secondDeclensionWords[indexPath.item].displayName
            }, thirdDeclension: {
                cell.textLabel?.text = thirdDeclensionWords[indexPath.item].displayName
            }, fourthDeclension: {
                cell.textLabel?.text = fourthDeclensionWords[indexPath.item].displayName
            }, fifthDeclension: {
                cell.textLabel?.text = fifthDeclensionWords[indexPath.item].displayName
            })
        }
        //Makes the cell the correct color.
        cell.backgroundColor = #colorLiteral(red: 1, green: 0.9375896303, blue: 0.04508237121, alpha: 0.2513912671)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if isSearching{
            return "Search"
        } else {
            var suggestedTitle = "Error"
            
            actions(section: section, firstDeclension: {
                suggestedTitle = "First Declension Words"
            }, secondDeclension: {
                suggestedTitle = "Second Declension Words"
            }, thirdDeclension: {
                suggestedTitle = "Third Declension Words"
            }, fourthDeclension: {
                suggestedTitle = "Fourth Declension Words"
            }, fifthDeclension: {
                suggestedTitle = "Fifth Declension Words"
            })
            
            return suggestedTitle
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if isSearching{
            return searchWords.count
        } else {
            
            var returnValue = 0
            
            actions(section: section, firstDeclension: {
                returnValue = firstDeclensionWords.count
            }, secondDeclension: {
                returnValue = secondDeclensionWords.count
            }, thirdDeclension: {
                returnValue = thirdDeclensionWords.count
            }, fourthDeclension: {
                returnValue = fourthDeclensionWords.count
            }, fifthDeclension: {
                returnValue = fifthDeclensionWords.count
            })
            
            return returnValue
        }
    }
    
    fileprivate func saveWords() {
        let wordList = firstDeclensionWords + secondDeclensionWords + thirdDeclensionWords + fourthDeclensionWords + fifthDeclensionWords
        var stringList: [String] = []
        
        for word in wordList{
            stringList.append(word.displayName)
        }
        
        storage.set(stringList, forKey: "userQuestions")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete{
            if isSearching{
                switch searchWords[indexPath.item].declensionNumber{
                case 1: for item in 0...firstDeclensionWords.count - 1{ if searchWords[indexPath.item] == firstDeclensionWords[item]{firstDeclensionWords.remove(at: item); searchWords.remove(at: indexPath.item); break}}
                case 2: for item in 0...secondDeclensionWords.count - 1{ if searchWords[indexPath.item] == secondDeclensionWords[item]{secondDeclensionWords.remove(at: item); searchWords.remove(at: indexPath.item); break}}
                case 3: for item in 0...thirdDeclensionWords.count - 1{ if searchWords[indexPath.item] == thirdDeclensionWords[item]{thirdDeclensionWords.remove(at: item); thirdGenders.remove(at: item); searchWords.remove(at: indexPath.item); break}}
                default: break
                }
                
                saveWords()
                
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                
            } else {
                if tableView.cellForRow(at: indexPath)?.isSelected != true{
                    disableButtons()
                }
                
                actions(section: indexPath.section, firstDeclension: {
                    firstDeclensionWords.remove(at: indexPath.item)
                }, secondDeclension: {
                    secondDeclensionWords.remove(at: indexPath.item)
                }, thirdDeclension: {
                    thirdDeclensionWords.remove(at: indexPath.item)
                    //thirdGenders.remove(at: indexPath.item)
                }, fourthDeclension: {
                    fourthDeclensionWords.remove(at: indexPath.item)
                }, fifthDeclension: {
                    fifthDeclensionWords.remove(at: indexPath.item)
                })
                
                saveWords()
                
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSearching{
            //An easy and simple-to-use implementation when using the search mechanism.
            questionList.removeAll()
            questionList.append(searchWords[indexPath.item])
            
        } else {
            questionList.removeAll()
            firstDeclensionQuestions.removeAll()
            secondDeclensionQuestions.removeAll()
            thirdDeclensionQuestions.removeAll()
            firstDeclensionEnabled = false
            secondDeclensionEnabled = false
            thirdDeclensionEnabled = false
            
            actions(section: indexPath.section, firstDeclension: {
                firstDeclensionQuestions.append(firstDeclensionWords[indexPath.item])
                questionList = firstDeclensionQuestions
            }, secondDeclension: {
                secondDeclensionQuestions.append(secondDeclensionWords[indexPath.item])
                questionList = secondDeclensionQuestions
            }, thirdDeclension: {
                thirdDeclensionQuestions.append(thirdDeclensionWords[indexPath.item])
                questionList = thirdDeclensionQuestions
            }, fourthDeclension: {
                fourthDeclensionQuestions.append(fourthDeclensionWords[indexPath.item])
                questionList = fourthDeclensionQuestions
            }, fifthDeclension: {
                fifthDeclensionQuestions.append(fifthDeclensionWords[indexPath.item])
                questionList = fifthDeclensionQuestions
            })
            
        }
        
        (parent as! CustomWordNavigator).questionList = questionList
        
        (parent as! CustomWordNavigator).firstDeclensionQuestions = firstDeclensionQuestions
        (parent as! CustomWordNavigator).secondDeclensionQuestions = secondDeclensionQuestions
        (parent as! CustomWordNavigator).thirdDeclensionQuestions = thirdDeclensionQuestions
        (parent as! CustomWordNavigator).fourthDeclensionQuestions = fourthDeclensionQuestions
        (parent as! CustomWordNavigator).fifthDeclensionQuestions = fifthDeclensionQuestions
        
        (parent as! CustomWordNavigator).firstDeclensionEnabled = firstDeclensionEnabled
        (parent as! CustomWordNavigator).secondDeclensionEnabled = secondDeclensionEnabled
        (parent as! CustomWordNavigator).thirdDeclensionEnabled = thirdDeclensionEnabled
        
        enableButtons()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        searchWords.removeAll()
        disableButtons()
        
        let combinedWords = firstDeclensionWords + secondDeclensionWords + thirdDeclensionWords + fourthDeclensionWords + fifthDeclensionWords
        
        let text = searchText.lowercased()
        
        ///smartIndex is used to prevent words from being used twice and to promote words towards the top when it believes it should.
        var smartIndex: Int? = nil
        
        if combinedWords.count > 0{
            //Primary Search
            for member in 0...combinedWords.count - 1{
                if combinedWords[member].contentsAsStringArray[0].lowercased().hasPrefix(text) || combinedWords[member].contentsAsStringArray[1].lowercased().hasPrefix(text) || combinedWords[member].displayName.lowercased().hasPrefix(text){
                    searchWords.append(combinedWords[member])
                }
            }
            
            //Secondary Search
            for member in 0...combinedWords.count - 1{
                if combinedWords[member].contentsAsStringArray[0].lowercased().hasSuffix(text) || combinedWords[member].contentsAsStringArray[1].lowercased().hasSuffix(text) || text.hasSuffix(combinedWords[member].contentsAsStringArray[0].lowercased()) || text.hasSuffix(combinedWords[member].contentsAsStringArray[1].lowercased()) || text.hasPrefix(combinedWords[member].contentsAsStringArray[0].lowercased()) || text.hasPrefix(combinedWords[member].contentsAsStringArray[1].lowercased()){
                    
                    smartIndex = searchWords.index(of: combinedWords[member])
                    if smartIndex == nil{
                        searchWords.append(combinedWords[member])
                    } else {
                        searchWords.remove(at: smartIndex!)
                        smartIndex! -= 5
                        if smartIndex! < 0{
                            smartIndex = 0
                        }
                        searchWords.insert(combinedWords[member], at: smartIndex!)
                    }
                }
            }
            
            //Counts the number of "fake" suggestions.
            var stupidWords = 0
            
            //Adds remaining words below
            for member in 0...combinedWords.count - 1{
                smartIndex = searchWords.index(of: combinedWords[member])
                if smartIndex == nil{
                    searchWords.append(combinedWords[member])
                    stupidWords += 1
                }
            }
            
            //Removes stupidWords where logical
            if stupidWords != 0{
                for i in 1...text.count{
                    searchWords.removeLast()
                    if i == stupidWords{
                        break
                    }
                }
            }
        }
        
        //Reload data
        tableView!.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        disableButtons()
        
        //Resets the table to normal
        declensionsInUse = 0
        prepareWords()
        tableView!.reloadData()
    }
    
    func actions(section: Int, firstDeclension: ()->Void, secondDeclension: ()->Void, thirdDeclension: ()->Void, fourthDeclension: ()->Void, fifthDeclension: ()->Void){
        if section == 0{
            if shouldShowFirst{
                firstDeclension()
            }else if shouldShowSecond{
                secondDeclension()
            }else if shouldShowThird{
                thirdDeclension()
            }else if shouldShowFourth{
                fourthDeclension()
            }else if shouldShowFifth{
                fifthDeclension()
            }
        }else if section == 1{
            if shouldShowFirst{
                if shouldShowSecond{
                    secondDeclension()
                }else if shouldShowThird{
                    thirdDeclension()
                }else if shouldShowFourth{
                    fourthDeclension()
                }else if shouldShowFifth{
                    fifthDeclension()
                }
                
            }else if shouldShowSecond{
                if shouldShowThird{
                    thirdDeclension()
                }else if shouldShowFourth{
                    fourthDeclension()
                }else if shouldShowFifth{
                    fifthDeclension()
                }
                
            }else if shouldShowThird{
                if shouldShowFourth{
                    fourthDeclension()
                }else if shouldShowFifth{
                    fifthDeclension()
                }
                
            }else if shouldShowFourth{
                if shouldShowFifth{
                    fifthDeclension()
                }
            }
        }else if section == 2{
            if shouldShowSecond{
                if shouldShowThird{
                    thirdDeclension()
                }else if shouldShowFourth{
                    fourthDeclension()
                }else if shouldShowFifth{
                    fifthDeclension()
                }
                
            }else if shouldShowThird{
                if shouldShowFourth{
                    fourthDeclension()
                }else if shouldShowFifth{
                    fifthDeclension()
                }
                
            }else if shouldShowFourth{
                if shouldShowFifth{
                    fifthDeclension()
                }
            }
        }else if section == 3{
            if shouldShowThird{
                if shouldShowFourth{
                    fourthDeclension()
                }else if shouldShowFifth{
                    fifthDeclension()
                }
                
            }else if shouldShowFourth{
                if shouldShowFifth{
                    fifthDeclension()
                }
            }
        }else if section == 4{
            fifthDeclension()
        }
    }
    
    @IBAction func startAction(_ sender: UIBarButtonItem) {
        if storage.string(forKey: "defaultMode")! == "quickPractice"{
            (navigationController as! CustomWordNavigator).testType = .singleQuestionMode
        } else {
            (navigationController as! CustomWordNavigator).testType = .declinablesController
        }
        
        storage.set(storage.bool(forKey: "defaultScoreMacrons"), forKey: "scoreMacrons")
        navigationController!.pushViewController(storyboard!.instantiateViewController(withIdentifier: "NewPractice"), animated: true)
    }
    
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        modalPresentationStyle = .popover
        let shareMenu = UIActivityViewController(activityItems: [selectedWord.displayName.description], applicationActivities: nil)
        shareMenu.popoverPresentationController?.barButtonItem = sender
        present(shareMenu, animated: true, completion: nil)
    }
}

@available(iOS 11.0, *) extension CustomWordListController: UITableViewDragDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        
        actions(section: indexPath.section, firstDeclension: {
            dragItem.localObject = firstDeclensionWords[indexPath.item]
        }, secondDeclension: {
            dragItem.localObject = secondDeclensionWords[indexPath.item]
        }, thirdDeclension:  {
            dragItem.localObject = thirdDeclensionWords[indexPath.item]
        }, fourthDeclension: {
            dragItem.localObject = fourthDeclensionWords[indexPath.item]
        }, fifthDeclension: {
            dragItem.localObject = fifthDeclensionWords[indexPath.item]
        })
        
        return [dragItem]
    }
}

@available(iOS 11.0, *) extension CustomWordListController: UITableViewDropDelegate{
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool{
        var shouldReturnTrue = false
        for member in session.items{
            if member.localObject is AnswerChecker{
                shouldReturnTrue = true
            }
        }
        
        return shouldReturnTrue
    }
    
    func canHandle(_ session: UIDropSession) -> Bool{
        var shouldReturnTrue = false
        for member in session.items{
            if member.localObject is AnswerChecker{
                shouldReturnTrue = true
            }
        }
        
        return shouldReturnTrue
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal{
        if tableView.hasActiveDrag{
            if session.items.count > 1{
                return UITableViewDropProposal(operation: .cancel)
            } else {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        for member in coordinator.items{
            let object = member.dragItem.localObject as! AnswerChecker
            var changed = false
            
            if member.sourceIndexPath!.section == coordinator.destinationIndexPath!.section{
                changed = true
                
                actions(section: member.sourceIndexPath!.section, firstDeclension: {
                    firstDeclensionWords.remove(at: member.sourceIndexPath!.item)
                    firstDeclensionWords.insert(object, at: coordinator.destinationIndexPath!.item)
                }, secondDeclension: {
                    secondDeclensionWords.remove(at: member.sourceIndexPath!.item)
                    secondDeclensionWords.insert(object, at: coordinator.destinationIndexPath!.item)
                }, thirdDeclension: {
                    thirdDeclensionWords.remove(at: member.sourceIndexPath!.item)
                    thirdDeclensionWords.insert(object, at: coordinator.destinationIndexPath!.item)
                }, fourthDeclension: {
                    fourthDeclensionWords.remove(at: member.sourceIndexPath!.item)
                    fourthDeclensionWords.insert(object, at: coordinator.destinationIndexPath!.item)
                }, fifthDeclension: {
                    fifthDeclensionWords.remove(at: member.sourceIndexPath!.item)
                    fifthDeclensionWords.insert(object, at: coordinator.destinationIndexPath!.item)
                })
                
            }
            
            if changed{
                saveWords()
                tableView.moveRow(at: member.sourceIndexPath!, to: coordinator.destinationIndexPath!)
                if storage.bool(forKey: "alphabetize"){
                    confirmDealphabetize(self)
                }
            }
        }
    }
    
    func confirmDealphabetize(_ viewController: UIViewController){
        let confirmCloseGame = UIAlertController(title: "Disable Alphabetization?", message: "Confirming this option will disable automatically alphabetizing each section of the table and permanantly leave this row in the position relative to the other rows in this section.", preferredStyle: .alert)
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmOption = UIAlertAction(title: "Confirm", style: .default) { (confirmOption) in
            self.storage.set(false, forKey: "alphabetize")
        }
        confirmCloseGame.addAction(confirmOption)
        confirmCloseGame.addAction(cancelOption)
        viewController.present(confirmCloseGame, animated: true, completion: nil)
    }
}
