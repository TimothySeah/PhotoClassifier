//
//  Testing.swift
//  PhotoClassifier
//
//  Created by Timothy Seah on 3/28/16.
//  Copyright © 2016 Timothy Seah. All rights reserved.
//
// A class used to test various parts of the app
// overfishing: learn how to use XCode testing if necessary

import Foundation

class Testing {
    
    // MARK: - Print stuff stored on phone
    
    // print the features currently stored in the app
    static func printFeatures() {
        if let Xu = NSKeyedUnarchiver.unarchiveObjectWithFile(Constants.XuURL.path!) as? [[String: Double]] {
            print(Xu)
        } else {
            print("No features stored")
        }
    }
    
    //
}