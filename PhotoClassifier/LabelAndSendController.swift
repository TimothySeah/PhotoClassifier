//
//  LabelAndSendController.swift
//  PhotoClassifier
//
//  Created by Timothy Seah on 3/3/16.
//  Copyright © 2016 Timothy Seah. All rights reserved.
//

import UIKit

class LabelAndSendController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var categoryPicker: UIPickerView!
    let categories = Constants.CATEGORIES
    
    @IBOutlet weak var labelPicker: UIPickerView!
    let labels = Constants.LABELS
    
    // overfishing: values only provided for irises so far
    @IBOutlet var irisDimensions: [UITextField]!
    let irisFields = Constants.IRISFIELDS
    
    
    // MARK: - basic picker functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // return number of rows in pickerview
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return categories.count
        } else {
            let index = categoryPicker.selectedRowInComponent(0)
            return labels[index].count
        }
    }
    
    // return the currently selected item in the picker view
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return categories[row]
        } else {
            let index = categoryPicker.selectedRowInComponent(0)
            return labels[index][row]
        }
    }
    
    // when the user changes the selected category, refresh labelPicker
    // done to prevent invalid category / label combinations
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            labelPicker.reloadAllComponents()
        }
    }
    
    //
    
    
    // send the user's classification of the image shown in the previous view
    // the classification's category is specified by categoryPicker
    // the classification's label is specified by labelPicker
    @IBAction func sendClassification(sender: UIButton) {
        
        // if text fields not filled in / invalid, dont send
        for tf in irisDimensions {
            guard let _ = Double(tf.text!) else {
                print("Invalid text field!")
                return
            }
        }
        
        // if userid not set yet (aka Tu not defined yet), set it and dont send features yet
        let defaults = NSUserDefaults.standardUserDefaults()
        guard let _ = defaults.objectForKey("UserID") else {
            print("Dont send label yet: userid not yet defined")
            Constants.initTu()
            return
        }
        
        
        // define content to send
        let catVal = categories[categoryPicker.selectedRowInComponent(0)]
        let labVal = labels[categoryPicker.selectedRowInComponent(0)][labelPicker.selectedRowInComponent(0)]
        var features = [String: Double]()
        var featuresArr = [[Double]](count: Constants.F["Irises"]!, repeatedValue: [0.0])
        for i in 0...(irisDimensions.count-1) {
            features[irisFields[i]] = Double(irisDimensions[i].text!)
            featuresArr[i][0] = features[irisFields[i]]!
        }
        let Ru = NSKeyedUnarchiver.unarchiveObjectWithFile(Constants.RuURL.path!) as! [[Double]]
        let uid = defaults.objectForKey("UserID")
        let content = ["category": catVal, "label": labVal, "features": Constants.matrixMultiply(Ru, m2: featuresArr), "userid": uid as! String]
        
        // send the request with completionHandler
        Constants.sendJSONPostData(Constants.URL_NEWPOINT, content: content as! [String : AnyObject], completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                
                // make sure we get a 200 response
                // only save the features on the phone if the transmission was successful
                // overfishing: better way to ensure success?
                guard let realResponse = response as? NSHTTPURLResponse where realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
                }
                
                // overfishing
                //Testing.printFeatures()
                
                // save on phone only if transmission was successful
                self.saveFeatures(features, label: labVal)
            
                // overfishing
                //Testing.printFeatures()
                
                // read the data
                if let postString = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String {
                    // Print what we got from the call
                    print("POST: " + postString)
                }
        })
    }
    
    // save new feature data (with label) on phone
    // overfishing: generalize so can store vehicles, etc not just irises
    func saveFeatures(features: [String: Double], label: String) {
        
        // overfishing: make sure this succeeds
        if var Xu = NSKeyedUnarchiver.unarchiveObjectWithFile(Constants.XuURL.path!) as? [[String: Double]], var yu = NSKeyedUnarchiver.unarchiveObjectWithFile(Constants.yuURL.path!) as? [String] {
            
            // only store MAX_POINTS features
            while Xu.count >= Constants.MAX_POINTS["Irises"] {
                Xu.removeAtIndex(0)
                yu.removeAtIndex(0)
            }
            
            // save updated features
            Xu.append(features)
            yu.append(label)
            NSKeyedArchiver.archiveRootObject(Xu, toFile: Constants.XuURL.path!)
            NSKeyedArchiver.archiveRootObject(yu, toFile: Constants.yuURL.path!)
            
            // send mean and covariance matrices to server upon reaching MAX_POINTS features
            if Xu.count >= Constants.MAX_POINTS["Irises"] {
                let defaults = NSUserDefaults.standardUserDefaults()
                if (!defaults.boolForKey("hasSentMC")) {
                    sendMeansCovs(Xu)
                    defaults.setBool(true, forKey: "hasSentMC") // mark as sent
                }
            }
        } else { // if first time
            NSKeyedArchiver.archiveRootObject([features], toFile: Constants.XuURL.path!)
            NSKeyedArchiver.archiveRootObject([label], toFile: Constants.yuURL.path!)
        }
    }
    
    // compute and send the mean and covariance matrices to the server
    // means is [String: Double] while covs is [[Double]]
    // overfishing: please test this
    func sendMeansCovs(Xu: [[String: Double]]) {
        
        // create mean matrix
        var means: [String: Double] = Xu[0]
        for i in 1...(Xu.count-1) {
            for (key, _) in Xu[i] {
                means[key] = means[key]! + Xu[i][key]!
            }
        }
        for (key, _) in means {
            means[key]  = means[key]! / Double(Xu.count)
        }
        
        // create covariance matrix
        // note: divided by n not n-1
        let F = Constants.F["Irises"]!
        let covRow = [Double](count: F, repeatedValue: 0.0)
        var covs = [[Double]](count: F, repeatedValue: covRow)
        for i in 0...(F-1) {
            for j in 0...(F-1) {
                for k in 0...(Xu.count-1) {
                    covs[i][j] += (Xu[k][irisFields[i]]! - means[irisFields[i]]!) * (Xu[k][irisFields[j]]! - means[irisFields[j]]!)
                }
            }
        }
        for i in 0...(F-1) {
            for j in 0...(F-1) {
                covs[i][j] /= Double(Xu.count)
            }
        }
        
        // send both
        let defaults = NSUserDefaults.standardUserDefaults()
        let uid = defaults.objectForKey("UserID")
        let content = ["means": means, "covs": covs, "userid": uid!]
        Constants.sendJSONPostData(Constants.URL_MEANCOV, content: content, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            // make sure we get a 200 response
            // only save the features on the phone if the transmission was successful
            // overfishing: better way to ensure success?
            guard let realResponse = response as? NSHTTPURLResponse where realResponse.statusCode == 200 else {
                print("Not a 200 response")
                return
            }
            
            // read the json
            if let postString = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                print("POST: " + postString)
            }
        })
    }
    
    //
    
    // MARK: - UIViewController basic functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // sort the irisDimensions array by tag
        irisDimensions.sortInPlace {(tf1: UITextField, tf2: UITextField) -> Bool in
            tf1.tag < tf2.tag
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
