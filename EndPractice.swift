//
//  EndPractice.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 3/18/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import UIKit

final class EndPractice: UIViewController{
    var firstAppearance = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Fix issues with pageDots
        (parent!.parent! as! PracticeScreen).memberNumber = (parent!.parent! as! PracticeScreen).findMemberNumber(forController: self)
        (parent!.parent! as! PracticeScreen).pageDots.currentPage = (parent!.parent! as! PracticeScreen).memberNumber
        
        if firstAppearance && (parent!.parent! as! PracticeScreen).allowShowing{
            
            guard (parent!.parent! as! PracticeScreen).scoreEnabled else{
                let confirmCloseGame = UIAlertController(title: "Get Scores", message: "You originally chose not to score your practice. Would you like to score it anyway?", preferredStyle: .alert)
                let viewResults = UIAlertAction(title: "Score", style: .cancel) { (confirmOption) in
                    guard self.parent!.parent! is PracticeScreen else {
                        self.firstAppearance = false
                        self.navigationController!.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "Results"))!, animated: true)
                        return
                    }
                    
                    (self.parent!.parent! as! PracticeScreen).allowShowing = false
                    self.firstAppearance = false
                    self.navigationController!.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "Results"))!, animated: true)
                }
                
                let closingOption = UIAlertAction(title: "Close Practice", style: .destructive) { (confirmOption) in
                    self.navigationController!.popViewController(animated: true)
                }
                
                confirmCloseGame.addAction(viewResults)
                confirmCloseGame.addAction(closingOption)
                present(confirmCloseGame, animated: true, completion: nil)
                
                return
            }
            
            (parent!.parent! as! PracticeScreen).allowShowing = false
            firstAppearance = false
            navigationController!.pushViewController((storyboard?.instantiateViewController(withIdentifier: "Results"))!, animated: true)
        }
    }
}
