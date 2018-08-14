//
//  ButtonComparer.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 1/20/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit

var storage = UserDefaults()

final class ButtonComparer: UIButton{
    var userAnswer: String? = nil
    var correctAnswer: String? = nil
    var userAnswerLowercased: String? { get{ return userAnswer?.lowercased()}}
    var correctAnswerLowercased: String? { get{ return correctAnswer?.lowercased()}}
    var userAnswerIsCorrect: Bool{ get{if storage.bool(forKey: "scoreMacrons"){ if userAnswerLowercased == correctAnswerLowercased{return true} else {return false}} else {if userAnswerLowercased?.removeMacrons() == correctAnswerLowercased?.removeMacrons(){return true} else {return false}}}}
    var noUserAnswerEntered: Bool{ get{ if userAnswer == nil{return true} else {return false}}}
}
