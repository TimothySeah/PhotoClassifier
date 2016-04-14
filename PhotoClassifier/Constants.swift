//
//  Constants.swift
//  PhotoClassifier
//
//  Created by Timothy Seah on 3/27/16.
//  Copyright © 2016 Timothy Seah. All rights reserved.
//
//  Contains constants that are useful throughout the entire app
//  Also contains functions useful throughout the entire app

import Foundation

class Constants {
    
    // storage locations
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let RuURL = DocumentsDirectory.URLByAppendingPathComponent("Ru")
    static let euURL = DocumentsDirectory.URLByAppendingPathComponent("eu")
    static let XuURL = DocumentsDirectory.URLByAppendingPathComponent("Xu")
    static let yuURL = DocumentsDirectory.URLByAppendingPathComponent("yu")
    
    // api endpoints
    // overfishing: change to match actual server
    static let URL_NEWPOINT = "http://192.168.0.15:8000"
    static let URL_MEANCOV = "http://192.168.0.15:8000/meancov"
    static let URL_INIT = "http://192.168.0.15:8000/init"
    static let URL_INIT2 = "http://192.168.0.15:8000/init2"
    
    // matrix dimensions
    static let F = ["Irises": 4]
    static let Q = ["Irises": 2]
    
    // max number of data points to be stored on phone
    static let MAX_POINTS = ["Irises": 5]
    
    // picker view data
    static let CATEGORIES = ["Irises", "Vehicles"]
    static let LABELS = [["Iris setosa", "Iris virginica", "Iris versicolor"], ["double decker bus", "Chevrolet van", "Saab 9000", "Opel Manta 400"]]
    static let IRISFIELDS = ["Sepal Length", "Sepal Width", "Petal length", "Petal Width"]
    
    
    // MARK: - Functions
    
    // multiply two matrices represented as 2d arrays 
    static func matrixMultiply(m1: [[Double]], m2: [[Double]]) -> [[Double]] {
        
        guard m1[0].count == m2.count else {
            print("Cannot multiply matrices with these dimensions")
            return [[]]
        }
        
        let row = [Double](count: m2[0].count, repeatedValue: 0.0)
        var mat = [[Double]](count: m1.count, repeatedValue: row)
        
        for i in 0...(m1.count-1) {
            for j in 0...(m2[0].count-1) {
                for k in 0...(m2.count-1) {
                    mat[i][j] += m1[i][k] * m2[k][j]
                }
            }
        }
        
        return mat
    }
    
    // add two matrices together and return their sum
    static func matrixAdd(m1: [[Double]], m2: [[Double]]) -> [[Double]]? {
        if m1.count != m2.count || m1[0].count != m2[0].count {
            print("matrix dimensions do not match!")
            return nil
        }
        
        let row = [Double](count: m1[0].count, repeatedValue: 0.0)
        var mat = [[Double]](count: m1.count, repeatedValue: row)
        for i in 0...(m1.count-1) {
            for j in 0...(m1[0].count-1) {
                mat[i][j] = m1[i][j] + m2[i][j]
            }
        }
        return mat
    }
    
    // return a random matrix of type [[Double]]. multiplier is applied to each value; with multiplier of 1 the values range from 0 to 1
    static func getRandomMatrix(rows: Int, cols: Int, multiplier: Double) -> [[Double]] {
        let row = [Double](count: cols, repeatedValue: 0.0)
        var mat = [[Double]](count: rows, repeatedValue: row)
        for i in 0...(rows-1) {
            for j in 0...(cols-1) {
                mat[i][j] = Double(Double(arc4random())/Double(UINT32_MAX)) * multiplier
            }
        }
        return mat
    }
    
    // send CONTENT to URL using POST/JSON
    static func sendJSONPostData(URL: String, content: AnyObject, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: URL)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(content, options: NSJSONWritingOptions())
        } catch {
            print("error occurred")
        }
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request, completionHandler: completionHandler).resume()
    }
}