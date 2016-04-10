//
//  MainViewController.swift
//  CollectionView_Roshan
//
//  Created by Roshan Thapaliya on 4/9/16.
//  Copyright © 2016 Roshan Thapaliya. All rights reserved.
//

import UIKit
import Social
import Firebase

class MainViewController: UIViewController{
    
    var image_select = UIImage();
    var name_player = NSString();
    var datePicker = UIDatePicker()
    let firebase = Firebase(url:"https://277roshan.firebaseio.com/profiles")
    
    
    @IBOutlet var detailImageOutlet: UIImageView!
    
    
    
    @IBOutlet var dateTextField: UITextField!
  
    
   override func viewDidLoad() {
        detailImageOutlet.image = image_select
        initializeDatePicker()
        
    }
    
    @IBAction func shareText(sender: UIButton) {
        let activityViewController = UIActivityViewController(
            activityItems: [dateTextField.text! as NSString],
            applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func facebookOnlySharePushed(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText(dateTextField.text! as String)
            facebookSheet.addImage(detailImageOutlet.image);
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
}


extension MainViewController {
    
    //
    // initialize the datePicker and create toolbar with buttons to manage the interaction
    //
    func initializeDatePicker() {
        
        datePicker.datePickerMode = UIDatePickerMode.Date;
        
        // this will make the picker appear, when the date
        // needs to be set
        dateTextField.inputView = datePicker
        dateTextField.textAlignment = .Center
        
        // set the tool bar
        let toolBar = UIToolbar(frame: CGRect.init(x:0, y:0, width:320, height:44))
        toolBar.tintColor = UIColor.grayColor()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "datePickerChanged")
        
        let canelBtn = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "datePickerCancelled")
        
        let spacerBtn = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([canelBtn,spacerBtn,doneBtn], animated: true)
        dateTextField.inputAccessoryView = toolBar
        
    }
    
    //
    // when the user clicks the button, set the focus on the text field and this will
    // force the dialog to display
    //
    @IBAction func datePickerBtnClicked(sender: AnyObject) {
        dateTextField.becomeFirstResponder()
    }
    
    //
    // when user cancels, just resign first responder and keep it moving
    func datePickerCancelled() {
        dateTextField.resignFirstResponder()
    }
    
    //
    // when the datePicker is completed from the done button, this is called to format the date
    // and then respond first responder to hide the datePicker
    //
    func datePickerChanged() {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        dateTextField.text = strDate
        dateTextField.resignFirstResponder()
    }
}

//Saving to firebase and querying from database
extension MainViewController{
    
    @IBAction func save(sender: AnyObject) {
        
        let date = dateTextField.text
        var data: NSData = NSData()
        
        if let image = detailImageOutlet.image {
            data = UIImageJPEGRepresentation(image,0.1)!
        }
        
        let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let user: NSDictionary = ["name":name_player,"date":date!, "photoBase64":base64String]
        
        //add firebase child node
        let profile = firebase.ref.childByAppendingPath(name_player as String)
        
        // Write data to Firebase
        profile.setValue(user)
        
        print("Data has been saved")
    }
    
  
    @IBAction func query(sender: AnyObject) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        firebase.observeEventType(.Value, withBlock: { snapshot in
            var tempItems = [NSDictionary]()
            
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                let dict = child.value as! NSDictionary
                tempItems.append(dict)
            }
            
            print(tempItems)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    
}