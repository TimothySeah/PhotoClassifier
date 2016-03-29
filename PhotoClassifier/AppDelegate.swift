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
        // Override point for customization after application launch.
        
        // generate and save random matrix Ru if it does not already exist
        guard let _ = NSKeyedUnarchiver.unarchiveObjectWithFile(Constants.RuURL.path!) as? [[Double]] else {
            
            print("FIRST TIME")
            
            // generate Ru from a uniform distribution
            // overfishing: paper says "either a gaussian or a uniform distribution"
            let rows = Constants.Q["Irises"]
            let cols = Constants.F["Irises"]
            let RuRow = [Double](count: cols!, repeatedValue: 0.0)
            var Ru = [[Double]](count: rows!, repeatedValue: RuRow)
            for i in 0...(rows!-1) {
                for j in 0...(cols!-1) {
                    Ru[i][j] = Double(Double(arc4random())/Double(UINT32_MAX))
                }
            }
            
            // save and return true iff the result was successful
            return NSKeyedArchiver.archiveRootObject(Ru, toFile: Constants.RuURL.path!)
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

