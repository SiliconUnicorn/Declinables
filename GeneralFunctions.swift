//
//  GeneralFunctions.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 1/21/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit

func confirmClose(_ viewController: UIViewController){
    let confirmCloseGame = UIAlertController(title: "Confirm Practice Closure", message: "Closing this practice will cause all progress to be lost.", preferredStyle: .alert)
    let cancelOption = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let confirmOption = UIAlertAction(title: "Close Anyway", style: .destructive) { (confirmOption) in
        viewController.dismiss(animated: true, completion: nil)
    }
    confirmCloseGame.addAction(confirmOption)
    confirmCloseGame.addAction(cancelOption)
    viewController.present(confirmCloseGame, animated: true, completion: nil)
}
