//
//  AppDelegate.swift
//  PhotoClassifier
//
//  Created by Timothy Seah on 2/15/16.
//  Copyright © 2016 Timothy Seah. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // generate and save random matrix Ru if it does not already exist
        if let _ = NSKeyedUnarchiver.unarchiveObjectWithFile(Constants.RuURL.path!) as? [[Double]] {
            print("Ru already exists")
        } else {
            print("Ru does not exist yet")
            
            // generate Ru from a uniform distribution
            // overfishing: paper says "either a gaussian or a uniform distribution"
            let rows = Constants.Q["Irises"]!
            let cols = Constants.F["Irises"]!
            let Ru = Constants.getRandomMatrix(rows, cols: cols, multiplier: 1)
            
            // save
            NSKeyedArchiver.archiveRootObject(Ru, toFile: Constants.RuURL.path!)
        }
        
        // if the userid does not exist (this is the user's first time opening the app):
        // 1) save and send the userid
        // 2) initiate the workflow that results in the creation of Tu on the server side
        let defaults = NSUserDefaults.standardUserDefaults()
        if let _ = defaults.objectForKey("UserID") {
            print("userid already exists")
        } else {
            Constants.initTu()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

