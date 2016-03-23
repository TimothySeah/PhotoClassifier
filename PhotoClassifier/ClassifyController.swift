//
//  ClassifyController.swift
//  PhotoClassifier
//
//  Created by Timothy Seah on 2/17/16.
//  Copyright © 2016 Timothy Seah. All rights reserved.
//

import UIKit

class ClassifyController: UIViewController {
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var label: UILabel!
    
    
    // from the server, obtain the classification of the picture specified in the previous view, which has the category specified in pickerView.
    // then display that classification in label
    @IBAction func getClassification(sender: UIButton) {
        
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
