//
//  PhotoTakerController.swift
//  PhotoClassifier
//
//  Created by Timothy Seah on 2/17/16.
//  Copyright © 2016 Timothy Seah. All rights reserved.
//

import UIKit

class PhotoTakerController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var currentImage: UIImageView!
    
    // when usePhoto button pressed, segue to next screen
    @IBAction func usePhoto(sender: UIButton) {
        if let _ = currentImage.image {
            //print("The ImageView contains an image")
            self.performSegueWithIdentifier("usePhoto", sender: sender)
        } else {
            //print("The ImageView does not contain an image")
        }
    }

    
    @IBAction func viewPhotos(sender: UIButton) {
        
        // if photo library is available
        if (UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            presentViewController(imagePicker, animated: true, completion: {})
        } else {
            postAlert("No photo library", message: "Application cannot access photo library")
        }
        
    }
    
    @IBAction func takePicture(sender: UIButton) {
        
        // if camera is available, bring up imagepicker
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
                presentViewController(imagePicker, animated: true, completion: {})
            } else {
                postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    // imagepickercontroller delegate method
    // if taking picture, save picture and dismiss
    // if viewing photo, simply display it in the imageview
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Got an image")
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            if picker.sourceType == .Camera {
                let selectorToCall = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
                UIImageWriteToSavedPhotosAlbum(pickedImage, self, selectorToCall, nil)
            }
            else if picker.sourceType == .PhotoLibrary {
                print("Source type is Photo Library")
            }
            self.currentImage.image = pickedImage
        }
        picker.dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user saves an image
        })
    }
    
    // imagepickercontroller delegate method, dismiss if user cancelled
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    // what to do when image was saved successfully/unsuccessfully
    // called by selector
    func imageWasSavedSuccessfully(image: UIImage, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>) {
        //print("Image saved")
        if let theError = error {
            print("An error happened while saving the image = \(theError)")
        }
    }
    
    
    
    // MARK: - overriden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         // set this controller as camera delegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - general helper methods
    
    // pop up a simple alert
    func postAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }


    // MARK: - Navigation

    // triggered by clicking "Use Photo"
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // if usePhoto pressed, send the image to the destination controller
        if segue.identifier == "usePhoto" {
            let nextScene = segue.destinationViewController as! ClassifyOrLabelController
            nextScene.currentPhoto = currentImage.image
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    

}
