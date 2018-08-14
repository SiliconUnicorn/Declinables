//
//  InteractiveDeclensionChart.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 3/20/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import Foundation
import UIKit

final class InteractiveDeclensionChart: UIViewController{
    
    @IBOutlet weak var declensionSelector: UISegmentedControl!
    @IBOutlet weak var neuterSwitch: UISwitch!
    
    @IBOutlet weak var embeddedView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .default}
    
    let storage = UserDefaults()
    
    var isNeuter = false
    weak var pageController: UIPageViewController? = nil
    weak var currentPage: ChartPage? = nil
    
    weak var presenter: UIViewController? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        pageController = (childViewControllers[0] as! UIPageViewController)
        pageController!.dataSource = self
        currentPage = (storyboard!.instantiateViewController(withIdentifier: "ChartPage") as! ChartPage)
        
        guard storage.string(forKey: "SpecialSuggestion") != nil else { return }
        
        switch storage.string(forKey: "SpecialSuggestion")!{
        case "REVIEW: First Declension": currentPage?.selectedDeclension = .first
        case "REVIEW: Second Declension": currentPage?.selectedDeclension = .second
        case "REVIEW: Third Declension": currentPage?.selectedDeclension = .third
        case "REVIEW: Fourth Declension": currentPage?.selectedDeclension = .fourth
        case "REVIEW: Fifth Declension": currentPage?.selectedDeclension = .fifth
        default: break
        }
        
        defer{
            pageController!.setViewControllers([currentPage!], direction: .forward, animated: false, completion: nil)
            (presentingViewController as! CustomWordNavigator).hiddenStatusStyle = .default
            (presentingViewController as! CustomWordNavigator).setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        pageController = (childViewControllers[0] as! UIPageViewController)
        pageController!.dataSource = self
        currentPage = (storyboard!.instantiateViewController(withIdentifier: "ChartPage") as! ChartPage)
        pageController!.setViewControllers([currentPage!], direction: .forward, animated: false, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        (presentingViewController as! CustomWordNavigator).hiddenStatusStyle = .lightContent
        (presentingViewController as! CustomWordNavigator).setNeedsStatusBarAppearanceUpdate()
    }
    
    fileprivate func setControllerDeclensions(for replacementController: ChartPage, with sender: UISwitch) {
        if sender.isOn{
            isNeuter = true
            
            switch declensionSelector.selectedSegmentIndex{
            case 1: replacementController.selectedDeclension = .secondNeuter
            case 2: replacementController.selectedDeclension = .thirdNeuter
            case 3: replacementController.selectedDeclension = .fourthNeuter
            default: fatalError("SANITY CHECK FAILED")
            }
            
        } else {
            isNeuter = false
            
            switch declensionSelector.selectedSegmentIndex{
            case 1: replacementController.selectedDeclension = .second
            case 2: replacementController.selectedDeclension = .third
            case 3: replacementController.selectedDeclension = .fourth
            default: fatalError("SANITY CHECK FAILED")
            }
        }
    }
    
    @IBAction func neuterSwitchChanged(_ sender: UISwitch) {
        guard declensionSelector.selectedSegmentIndex != 0 && declensionSelector.selectedSegmentIndex != 4 else{
            return
        }
        
        if sender.isOn{
            isNeuter = true
        } else {
            isNeuter = false
        }
        
        currentPage!.selectedDeclension.toggleNeuter()
        currentPage!.reloadText()
    }
    
    func setNeuterSwitchStatus(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 || sender.selectedSegmentIndex == 4{
            neuterSwitch.isEnabled = false
            neuterSwitch.isOn = false
        }else if isNeuter{
            neuterSwitch.isEnabled = true
            neuterSwitch.isOn = true
        } else {
            neuterSwitch.isEnabled = true
            neuterSwitch.isOn = false
        }
    }
    
    @IBAction func selectedDeclensionChanged(_ sender: UISegmentedControl) {
        setNeuterSwitchStatus(sender)
        
        let replacementController = (storyboard!.instantiateViewController(withIdentifier: "ChartPage") as! ChartPage)
        switch declensionSelector.selectedSegmentIndex{
        case 0: replacementController.selectedDeclension = .first
        case 1: if isNeuter{ replacementController.selectedDeclension = .secondNeuter} else { replacementController.selectedDeclension = .second}
        case 2: if isNeuter{ replacementController.selectedDeclension = .thirdNeuter} else { replacementController.selectedDeclension = .third}
        case 3: if isNeuter{ replacementController.selectedDeclension = .fourthNeuter} else { replacementController.selectedDeclension = .fourth}
        case 4: replacementController.selectedDeclension = .fifth
        default: fatalError("FAILED SANITY CHECK")
        }
        
        switch currentPage!.selectedDeclension{
        case .first:
            pageController!.setViewControllers([replacementController], direction: .forward, animated: true, completion: nil)
            
        case .second:
            if replacementController.selectedDeclension.declensionNumber <= 1{
                pageController!.setViewControllers([replacementController], direction: .reverse, animated: true, completion: nil)
            } else {
                pageController!.setViewControllers([replacementController], direction: .forward, animated: true, completion: nil)
            }
        case .third:
            if replacementController.selectedDeclension.declensionNumber <= 2{
                pageController!.setViewControllers([replacementController], direction: .reverse, animated: true, completion: nil)
            } else {
                pageController!.setViewControllers([replacementController], direction: .forward, animated: true, completion: nil)
            }
        case .secondNeuter:
            if replacementController.selectedDeclension.declensionNumber <= 1{
                pageController!.setViewControllers([replacementController], direction: .reverse, animated: true, completion: nil)
            } else {
                pageController!.setViewControllers([replacementController], direction: .forward, animated: true, completion: nil)
            }
        case .thirdNeuter:
            if replacementController.selectedDeclension.declensionNumber <= 2{
                pageController!.setViewControllers([replacementController], direction: .reverse, animated: true, completion: nil)
            } else {
                pageController!.setViewControllers([replacementController], direction: .forward, animated: true, completion: nil)
            }
        case .fourth:
            if replacementController.selectedDeclension.declensionNumber <= 3{
                pageController!.setViewControllers([replacementController], direction: .reverse, animated: true, completion: nil)
            } else {
                pageController!.setViewControllers([replacementController], direction: .forward, animated: true, completion: nil)
            }
        case .fourthNeuter:
            if replacementController.selectedDeclension.declensionNumber <= 3{
                pageController!.setViewControllers([replacementController], direction: .reverse, animated: true, completion: nil)
            } else {
                pageController!.setViewControllers([replacementController], direction: .forward, animated: true, completion: nil)
            }
        case .fifth:
            pageController!.setViewControllers([replacementController], direction: .reverse, animated: true, completion: nil)
        }
    }
    @IBAction func userRequestedDismissal(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension InteractiveDeclensionChart: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var resultingController: ChartPage? = (storyboard!.instantiateViewController(withIdentifier: "ChartPage") as! ChartPage)
        
        switch (viewController as! ChartPage).selectedDeclension{
        
        case .first:
            resultingController = nil
        case .second:
            resultingController!.selectedDeclension = .first
        case .third:
            resultingController!.selectedDeclension = .second
        case .secondNeuter:
            resultingController!.selectedDeclension = .first
        case .thirdNeuter:
            resultingController!.selectedDeclension = .secondNeuter
        case .fourth:
            resultingController!.selectedDeclension = .third
        case .fourthNeuter:
            resultingController!.selectedDeclension = .thirdNeuter
        case .fifth:
            if isNeuter{
                resultingController!.selectedDeclension = .fourthNeuter
            } else {
                resultingController!.selectedDeclension = .fourth
            }
        }
        
        return resultingController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var resultingController: ChartPage? = (storyboard!.instantiateViewController(withIdentifier: "ChartPage") as! ChartPage)
        
        switch (viewController as! ChartPage).selectedDeclension{
            
        case .first:
            if isNeuter{
                resultingController!.selectedDeclension = .secondNeuter
            } else {
                resultingController!.selectedDeclension = .second
            }
        case .second:
            resultingController!.selectedDeclension = .third
        case .third:
            resultingController!.selectedDeclension = .fourth
        case .secondNeuter:
            resultingController!.selectedDeclension = .thirdNeuter
        case .thirdNeuter:
            resultingController!.selectedDeclension = .fourthNeuter
        case .fourth:
            resultingController!.selectedDeclension = .fifth
        case .fourthNeuter:
            resultingController!.selectedDeclension = .fifth
        case .fifth:
            resultingController = nil
        }
        
        return resultingController
    }
}
