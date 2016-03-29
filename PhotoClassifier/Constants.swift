//
//  Constants.swift
//  PhotoClassifier
//
//  Created by Timothy Seah on 3/27/16.
//  Copyright © 2016 Timothy Seah. All rights reserved.
//
//  Contains constants that are useful throughout the entire app

import Foundation

class Constants {
    
    // storage locations
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let RuURL = DocumentsDirectory.URLByAppendingPathComponent("Ru")
    static let euURL = DocumentsDirectory.URLByAppendingPathComponent("eu")
    static let XuURL = DocumentsDirectory.URLByAppendingPathComponent("Xu")
    
    // api endpoints
    // overfishing: change to match actual server
    static let URL_NEWPOINT = "http://192.168.0.15:8000"
    static let URL_MEANCOV = "http://192.168.0.15:8000/meancov"
    
    // matrix dimensions
    static let F = ["Irises": 4]
    static let Q = ["Irises": 2]
    
    // max number of data points to be stored on phone
    static let MAX_POINTS = ["Irises": 5]
}