//
//  AppDelegate.swift
//  Declinables 2
//
//  Created by Micah Hansonbrook on 1/15/18.
//  Copyright © 2018 Micah Hansonbrook. All rights reserved.
//

import UIKit
import Foundation
import DeclinablesLibrary

@UIApplicationMain final class AppDelegate: UIResponder, UIApplicationDelegate {
    var shouldShowMenuOnLaunch = true
    var wasLaunched = false
    let storage = UserDefaults()
    
    let widgetStorage = UserDefaults(suiteName: "group.DeclinablesInternal")
    
    var window: UIWindow?

    fileprivate func saveWordsForUse(_ application: UIApplication) {
        ((application.keyWindow?.rootViewController as! CustomWordNavigator).viewControllers[0] as! MainMenu).setDefaultWords()
        ((application.keyWindow?.rootViewController as! CustomWordNavigator).viewControllers[0] as! MainMenu).addUserDefinedWords()
        ((application.keyWindow?.rootViewController as! CustomWordNavigator).viewControllers[0] as! MainMenu).saveWordsToNavigator(application.keyWindow?.rootViewController as! CustomWordNavigator)
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void){
        shouldShowMenuOnLaunch = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if shortcutItem == UIApplicationShortcutItem(type: "CustomWord", localizedTitle: "Custom Word", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "Start"), userInfo: nil){
            if application.keyWindow?.rootViewController is UINavigationController{
                (application.keyWindow?.rootViewController as! UINavigationController).pushViewController(storyboard.instantiateViewController(withIdentifier: "customWordAdder"), animated: false)
            }
        }
        if shortcutItem == UIApplicationShortcutItem(type: "PraticeFirstDeclension", localizedTitle: "First Declension", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "First Declension"), userInfo: nil){
            if application.keyWindow?.rootViewController is UINavigationController{
                
                saveWordsForUse(application)
                
                (application.keyWindow?.rootViewController as! UINavigationController).pushViewController(storyboard.instantiateViewController(withIdentifier: "SetupController"), animated: false)
                let baseViewController = ((application.keyWindow?.rootViewController as! UINavigationController).viewControllers[(application.keyWindow?.rootViewController as! UINavigationController).viewControllers.count - 1] as! SetupController)
                baseViewController.copyQuestionsFromLoader((application.keyWindow?.rootViewController as! CustomWordNavigator))
                baseViewController.secondDeclensionEnabled = false
                baseViewController.thirdDeclensionEnabled = false
                
                baseViewController.savePracticeComponents()
                (application.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: false)
                (application.keyWindow?.rootViewController as! UINavigationController).pushViewController(storyboard.instantiateViewController(withIdentifier: "NewPractice"), animated: false)
            }
        }
        
        if shortcutItem == UIApplicationShortcutItem(type: "PraticeSecondDeclension", localizedTitle: "Second Declension", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "Second Declension"), userInfo: nil){
            if application.keyWindow?.rootViewController is UINavigationController{
                
                saveWordsForUse(application)
                
                (application.keyWindow?.rootViewController as! UINavigationController).pushViewController(storyboard.instantiateViewController(withIdentifier: "SetupController"), animated: false)
                let baseViewController = ((application.keyWindow?.rootViewController as! UINavigationController).viewControllers[(application.keyWindow?.rootViewController as! UINavigationController).viewControllers.count - 1] as! SetupController)
                baseViewController.copyQuestionsFromLoader((application.keyWindow?.rootViewController as! CustomWordNavigator))
                baseViewController.firstDeclensionEnabled = false
                baseViewController.thirdDeclensionEnabled = false
                
                baseViewController.savePracticeComponents()
                (application.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: false)
                (application.keyWindow?.rootViewController as! UINavigationController).pushViewController(storyboard.instantiateViewController(withIdentifier: "NewPractice"), animated: false)
            }
        }
        
        if shortcutItem == UIApplicationShortcutItem(type: "PraticeThirdDeclension", localizedTitle: "Third Declension", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "Third Declension"), userInfo: nil){
            if application.keyWindow?.rootViewController is UINavigationController{
                
                saveWordsForUse(application)
                
                (application.keyWindow?.rootViewController as! UINavigationController).pushViewController(storyboard.instantiateViewController(withIdentifier: "SetupController"), animated: false)
                let baseViewController = ((application.keyWindow?.rootViewController as! UINavigationController).viewControllers[(application.keyWindow?.rootViewController as! UINavigationController).viewControllers.count - 1] as! SetupController)
                baseViewController.copyQuestionsFromLoader((application.keyWindow?.rootViewController as! CustomWordNavigator))
                baseViewController.secondDeclensionEnabled = false
                baseViewController.firstDeclensionEnabled = false
                
                baseViewController.savePracticeComponents()
                (application.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: false)
                (application.keyWindow?.rootViewController as! UINavigationController).pushViewController(storyboard.instantiateViewController(withIdentifier: "NewPractice"), animated: false)
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if (storage.array(forKey: "userQuestions")! as! [String]).index(of: "Error, Erroris (E)") != nil{
            widgetStorage!.set((storage.array(forKey: "userQuestions") as! [String]), forKey: "customWordList")
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        if (window?.rootViewController as! CustomWordNavigator).viewControllers[(window?.rootViewController as! CustomWordNavigator).viewControllers.count - 1] is MainMenu{
            (window?.rootViewController as! CustomWordNavigator).viewControllers[(window?.rootViewController as! CustomWordNavigator).viewControllers.count - 1].viewWillAppear(true)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //Prepare for 3D Touch
        let startIcon = UIApplicationShortcutIcon(templateImageName: "Start")
        let firstDeclension = UIApplicationShortcutIcon(templateImageName: "First Declension")
        let secondDeclension = UIApplicationShortcutIcon(templateImageName: "Second Declension")
        let thirdDeclension = UIApplicationShortcutIcon(templateImageName: "Third Declension")
        application.shortcutItems = [UIApplicationShortcutItem(type: "CustomWord", localizedTitle: "Custom Word", localizedSubtitle: nil, icon: startIcon, userInfo: nil), UIApplicationShortcutItem(type: "PraticeFirstDeclension", localizedTitle: "First Declension", localizedSubtitle: nil, icon: firstDeclension, userInfo: nil), UIApplicationShortcutItem(type: "PraticeSecondDeclension", localizedTitle: "Second Declension", localizedSubtitle: nil, icon: secondDeclension, userInfo: nil), UIApplicationShortcutItem(type: "PraticeThirdDeclension", localizedTitle: "Third Declension", localizedSubtitle: nil, icon: thirdDeclension, userInfo: nil)]
        
        if shouldShowMenuOnLaunch && wasLaunched == false{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //window!.rootViewController?.present(storyboard.instantiateViewController(withIdentifier: "MainMenu"), animated: false, completion: nil)
            storage.set(true, forKey: "noPracticesSinceLaunch")
            if storage.bool(forKey: "previouslyLaunched") != true{
                
                if UIDevice.current.model == "iPad" {
                    storage.set(false, forKey: "alphabetize")
                } else {
                    storage.set(true, forKey: "alphabetize")
                }
                
                //Knows it has been previously launched in future launches
                storage.set(true, forKey: "previouslyLaunched")

                
                storage.set(["Error, Erroris (E)"], forKey: "userQuestions")
                
                //Default Question Controls
                storage.set("quickPractice", forKey: "defaultMode")
                storage.set(5, forKey: "defaultQuestionCount")
                storage.set(true, forKey: "defaultScoreMacrons")
                
                //Prevents a status bar issue
                storage.set("None", forKey: "SpecialSuggestion")
                
                //Auto-enables the scoring of macrons.
                storage.set(true, forKey: "scoreMacrons")
                
                let welcomeScreen = storyboard.instantiateViewController(withIdentifier: "WelcomeScreen")
                welcomeScreen.modalPresentationStyle = .overCurrentContext
                
                window?.rootViewController!.present(welcomeScreen, animated: true, completion: nil)
            }
        }
        wasLaunched = true
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

