//
//  ClassifyOrLabelController.swift
//  PhotoClassifier
//
//  Created by Timothy Seah on 2/17/16.
//  Copyright © 2016 Timothy Seah. All rights reserved.
//

import UIKit

class ClassifyOrLabelController: UIViewController {
    
    var currentPhoto: UIImage?
    @IBOutlet weak var currentImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // once view loads, load in image
        currentImage.image = currentPhoto
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
