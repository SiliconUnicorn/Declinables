//
//  ChartPage.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 3/20/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit
import DeclinablesLibrary

final class ChartPage: UIViewController{
    @IBOutlet weak var singularNominative: UILabel!
    @IBOutlet weak var singularGenitive: UILabel!
    @IBOutlet weak var singularDative: UILabel!
    @IBOutlet weak var singularAccusative: UILabel!
    @IBOutlet weak var singularAblative: UILabel!
    @IBOutlet weak var singularVocative: UILabel!
    
    @IBOutlet weak var pluralNominative: UILabel!
    @IBOutlet weak var pluralGenitive: UILabel!
    @IBOutlet weak var pluralDative: UILabel!
    @IBOutlet weak var pluralAccusative: UILabel!
    @IBOutlet weak var pluralAblative: UILabel!
    @IBOutlet weak var pluralVocative: UILabel!
    
    var selectedDeclension: Declensions = Declensions.first
    var correctEndings: AnswerChecker{ return AnswerChecker(createKeyWith: selectedDeclension)}
    
    func reloadText() {
        singularNominative.text = correctEndings.correctAnswers[0]
        singularGenitive.text = correctEndings.correctAnswers[1]
        singularDative.text = correctEndings.correctAnswers[2]
        singularAccusative.text  = correctEndings.correctAnswers[3]
        singularAblative.text = correctEndings.correctAnswers[4]
        singularVocative.text = correctEndings.correctAnswers[5]
        pluralNominative.text = correctEndings.correctAnswers[6]
        pluralGenitive.text = correctEndings.correctAnswers[7]
        pluralDative.text = correctEndings.correctAnswers[8]
        pluralAccusative.text = correctEndings.correctAnswers[9]
        pluralAblative.text = correctEndings.correctAnswers[10]
        pluralVocative.text = correctEndings.correctAnswers[11]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (parent!.parent! as! InteractiveDeclensionChart).currentPage = self
        (parent!.parent! as! InteractiveDeclensionChart).declensionSelector.selectedSegmentIndex = selectedDeclension.declensionNumber - 1
        (parent!.parent! as! InteractiveDeclensionChart).setNeuterSwitchStatus((parent!.parent! as! InteractiveDeclensionChart).declensionSelector)
    }
}
