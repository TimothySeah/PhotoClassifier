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
    let categories = ["Irises", "Vehicles"]
    
    @IBOutlet weak var labelPicker: UIPickerView!
    let labels = [["Iris setosa", "Iris virginica", "Iris versicolor"], ["double decker bus", "Chevrolet van", "Saab 9000", "Opel Manta 400"]]
    
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
        
        // define url and content, user-selected values for category and label
        let url = NSURL(string: "http://192.168.0.15:8000")! // overfishing change
        let catVal = categories[categoryPicker.selectedRowInComponent(0)]
        let labVal = labels[categoryPicker.selectedRowInComponent(0)][labelPicker.selectedRowInComponent(0)]
        let content = ["category": catVal, "label": labVal]
        
        // define request (post, json in body, etc)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(content, options: NSJSONWritingOptions())
        } catch {
            print("error occurred")
        }
        
        // make request
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request, completionHandler:
            { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                
                // make sure we get a 200 response
                guard let realResponse = response as? NSHTTPURLResponse where realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
                }
                
                // read the json
                if let postString = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String {
                    // Print what we got from the call
                    print("POST: " + postString)
                }
        }).resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
