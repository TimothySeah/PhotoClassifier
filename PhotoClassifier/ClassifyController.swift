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
    
    @IBOutlet weak var classification: UILabel!
    let labels = Constants.LABELS
    
    
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
        print("WHATS GOOD")
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
