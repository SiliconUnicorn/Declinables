//
//  PracticeHeading.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 2/26/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit
import DeclinablesLibrary

final class PracticeHeading: UIViewController, Practiceable{
    @IBOutlet weak var mainTitle: UILabel!
    
    var userInteraction: StandardPracticeInteractionController{ get{ return (childViewControllers[0] as! StandardPracticeInteractionController)}}
    
    var viewControllerNoun = AnswerChecker("Puella", "Puellae")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Fix issues with pageDots
        (parent!.parent! as! PracticeScreen).memberNumber = (parent!.parent! as! PracticeScreen).findMemberNumber(forController: self)
        (parent!.parent! as! PracticeScreen).pageDots.currentPage = (parent!.parent! as! PracticeScreen).memberNumber
        (parent!.parent! as! PracticeScreen).currentController = self
        
        mainTitle.text = viewControllerNoun.displayName
        
        userInteraction.singularNominativeText.text = viewControllerNoun.userAnswers[0]
        userInteraction.singularGenitiveText.text = viewControllerNoun.userAnswers[1]
        userInteraction.singularDativeText.text = viewControllerNoun.userAnswers[2]
        userInteraction.singularAccusativeText.text = viewControllerNoun.userAnswers[3]
        userInteraction.singularAblativeText.text = viewControllerNoun.userAnswers[4]
        userInteraction.singularVocativeText.text = viewControllerNoun.userAnswers[5]
        userInteraction.pluralNominativeText.text = viewControllerNoun.userAnswers[6]
        userInteraction.pluralGenitiveText.text = viewControllerNoun.userAnswers[7]
        userInteraction.pluralDativeText.text = viewControllerNoun.userAnswers[8]
        userInteraction.pluralAccusativeText.text = viewControllerNoun.userAnswers[9]
        userInteraction.pluralAblativeText.text = viewControllerNoun.userAnswers[10]
        userInteraction.pluralVocativeText.text = viewControllerNoun.userAnswers[11]
    }
    
    func saveUserInput(){
        viewControllerNoun.userAnswers = [userInteraction.singularNominativeText.text!, userInteraction.singularGenitiveText.text!, userInteraction.singularDativeText.text!, userInteraction.singularAccusativeText.text!, userInteraction.singularAblativeText.text!, userInteraction.singularVocativeText.text!, userInteraction.pluralNominativeText.text!, userInteraction.pluralGenitiveText.text!, userInteraction.pluralDativeText.text!, userInteraction.pluralAccusativeText.text!, userInteraction.pluralAblativeText.text!, userInteraction.pluralVocativeText.text!]
    }
}
