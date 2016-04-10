//
//  QueryPage.swift
//  CollectionView_Roshan
//
//  Created by Roshan Thapaliya on 4/10/16.
//  Copyright © 2016 Roshan Thapaliya. All rights reserved.
//

import UIKit
import Firebase

class QueryViewController: UIViewController{
    
    let firebase = Firebase(url:"https://277roshan.firebaseio.com/profiles")
    
    @IBOutlet var QueryText: UITextField!
    
    @IBOutlet var NameOutlet: UILabel!
    
    @IBOutlet var BirthOutlet: UILabel!
    
    @IBOutlet var imageDisplay: UIImageView!
    
    @IBAction func query(sender: AnyObject) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        firebase.observeEventType(.Value, withBlock: { snapshot in
            var tempItems = [NSDictionary]()
            
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                let dict = child.value as! NSDictionary
                tempItems.append(dict)
            }
            
            for i in tempItems{
            guard let item = i["name"], let date = i["date"],
                let imagea = i["photoBase64"]
                else{
                    return;
            }
                if self.QueryText.text == item as! String{
                    
                    self.NameOutlet.text = item as! String
                    self.BirthOutlet.text = date as! String
                    
                    let decodedData = NSData(base64EncodedString: imagea as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    
                    print(decodedData)
                    
                    let decodedImage = UIImage(data:decodedData!)
                    
                    self.imageDisplay.image = decodedImage! as UIImage
                    
                    
                }
            
            }
            
            

            
           
           
            
            
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}