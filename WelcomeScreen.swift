//
//  WelcomeScreen.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 1/29/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit

final class WelcomeScreen: UIViewController{
    @IBOutlet weak var iPadFeatureTitle: UILabel!
    @IBOutlet weak var iPadFeatureText: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UIDevice.current.model == "iPad"{
            iPadFeatureTitle.isHidden = false
            iPadFeatureText.isHidden = false
        } else {
            iPadFeatureTitle.isHidden = true
            iPadFeatureText.isHidden = true
        }
        
        (presentingViewController as! CustomWordNavigator).hiddenStatusStyle = .default
        (presentingViewController as! CustomWordNavigator).setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        (presentingViewController as! CustomWordNavigator).hiddenStatusStyle = .lightContent
        (presentingViewController as! CustomWordNavigator).setNeedsStatusBarAppearanceUpdate()
    }
    
    @IBAction func closeRequested(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
