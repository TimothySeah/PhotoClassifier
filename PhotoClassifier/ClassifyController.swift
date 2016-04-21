//
//  ClassifyController.swift
//  PhotoClassifier
//
//  Created by Timothy Seah on 2/17/16.
//  Copyright © 2016 Timothy Seah. All rights reserved.
//

import UIKit

class ClassifyController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    let categories = Constants.CATEGORIES
    
    @IBOutlet weak var classLabel: UILabel!
    let labels = Constants.LABELS
    
    @IBOutlet var irisDimensions: [UITextField]!
    let irisFields = Constants.IRISFIELDS
    
    
    
    // MARK: - basic picker functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // return number of rows in pickerview
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    // return the currently selected item in the picker view
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    //
    
    
    // from the server, obtain the classification of the picture specified in the previous view, which has the category specified in pickerView.
    // then display that classification in label
    // overfishing: this method is used for testing for now
    @IBAction func getClassification(sender: UIButton) {
        
        // if text fields not filled in / invalid, dont send
        for tf in irisDimensions {
            guard let _ = Double(tf.text!) else {
                print("Invalid text field!")
                return
            }
        }
        
        // define content to send
        let defaults = NSUserDefaults.standardUserDefaults()
        let catVal = categories[categoryPicker.selectedRowInComponent(0)]
        var featuresArr = [[Double]](count: Constants.F["Irises"]!, repeatedValue: [0.0])
        for i in 0...(irisDimensions.count-1) {
            featuresArr[i][0] = Double(irisDimensions[i].text!)!
        }
        let uid = defaults.objectForKey("UserID")
        let content = ["category": catVal, "features": featuresArr, "userid": uid as! String]
        
        // send request with completionHandler
        Constants.sendJSONPostData(Constants.URL_GETCLASS, content: content as! [String : AnyObject], completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            // overfishing: better way to ensure success?
            guard let realResponse = response as? NSHTTPURLResponse where realResponse.statusCode == 200 else {
                print("Not a 200 response: could not reach server at URL_GETCLASS")
                self.classLabel.text = "Could not reach server"
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.classLabel.text = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String
            }
        })
    }
    
    // MARK: - Basic callback functions

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
    
    //
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
