//
//  StandardPracticeInteractionController.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 2/26/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit

final class StandardPracticeInteractionController: UIViewController{
    @IBOutlet weak var pluralNominativeText: UITextField!
    @IBOutlet weak var pluralGenitiveText: UITextField!
    @IBOutlet weak var pluralDativeText: UITextField!
    @IBOutlet weak var pluralAccusativeText: UITextField!
    @IBOutlet weak var pluralAblativeText: UITextField!
    @IBOutlet weak var pluralVocativeText: UITextField!
    @IBOutlet weak var singularNominativeText: UITextField!
    @IBOutlet weak var singularGenitiveText: UITextField!
    @IBOutlet weak var singularDativeText: UITextField!
    @IBOutlet weak var singularAccusativeText: UITextField!
    @IBOutlet weak var singularAblativeText: UITextField!
    @IBOutlet weak var singularVocativeText: UITextField!
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singularNominativeText.delegate = self
        singularGenitiveText.delegate = self
        singularDativeText.delegate = self
        singularAccusativeText.delegate = self
        singularAblativeText.delegate = self
        singularVocativeText.delegate = self
        pluralNominativeText.delegate = self
        pluralGenitiveText.delegate = self
        pluralDativeText.delegate = self
        pluralAccusativeText.delegate = self
        pluralAblativeText.delegate = self
        pluralVocativeText.delegate = self
    }
}


extension StandardPracticeInteractionController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        constraint.constant = 54
        (view.subviews[0] as! UIScrollView).scrollToView(view: textField, animated: true)
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        (view.subviews[0] as! UIScrollView).scrollToBottom(animated: true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        constraint.constant = 354
        (view.subviews[0] as! UIScrollView).scrollToView(view: textField, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (parent! as! PracticeHeading).saveUserInput()
    }
}
