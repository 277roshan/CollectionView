//
//  QueryPage.swift
//  CollectionView_Roshan
//
//  Created by Roshan Thapaliya on 4/10/16.
//  Copyright © 2016 Roshan Thapaliya. All rights reserved.
//

import UIKit
import Firebase

class QueryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let ref = Firebase(url:"https://277roshan.firebaseio.com")
    let firebase = Firebase(url:"https://277roshan.firebaseio.com/profiles")
    
    var tempItems: [NSDictionary] = []
    var tempItems2: [NSDictionary] = []
   let section:[String] = ["Public","Private"]
    var items:[AnyObject] = [[],[]]
    
    //let section = ["pizza", "deep dish pizza", "calzone"]
    
    //let items = [["Margarita", "BBQ Chicken", "Pepperoni"], ["sausage", "meat lovers", "veggie lovers"], ["sausage", "chicken pesto", "prawns", "mushrooms"]]
    
    @IBOutlet var TableViewOutlet: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewOutlet.delegate = self
        TableViewOutlet.dataSource = self
        query()
        
        
        
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.section.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.section [section]
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         print(tempItems.count)
        //print(tempItems)
        return self.items [section ].count
        
       
    }
    
   

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = TableViewOutlet.dequeueReusableCellWithIdentifier("firstCell", forIndexPath: indexPath) as! TableCellController
        let row = self.items[indexPath.section][indexPath.row]
        
        cell.Name.text = row["name"] as? String
        cell.Date.text = row["date"] as? String
        let imagea = row["photoBase64"]
        let decodedData = NSData(base64EncodedString: imagea as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data:decodedData!)
        cell.PlayerImage.image = decodedImage
        
        

        
        return cell
    }
    
   
    
    func query() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        firebase.observeEventType(.Value, withBlock: { snapshot in
            
            
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                let dict = child.value as! NSDictionary
                self.tempItems.append(dict)
            }
            
        self.items[0] = self.tempItems
        
            
            //print(self.tempItems)
            
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
        
        let privateUrl = "https://277roshan.firebaseio.com/private/" + self.ref.authData.uid
        let firebasePrivate = Firebase(url:privateUrl)
        
        firebasePrivate.observeEventType(.Value, withBlock: { snapshot in
            
            print(snapshot.children)
            
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                let dict = child.value as! NSDictionary
                self.tempItems2.append(dict)
                
            }
            
            print(self.tempItems2)
            
            self.items[1] = (self.tempItems2)
            
            
            
            //print(self.tempItems)
            
            self.TableViewOutlet.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        })

        
        
        
        
        
            }
}