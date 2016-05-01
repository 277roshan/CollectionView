//
//  FlickrPhotosViewController.swift
//  CollectionView_Roshan
//
//  Created by Roshan Thapaliya on 4/9/16.
//  Copyright © 2016 Roshan Thapaliya. All rights reserved.
//

import UIKit
import Firebase


class CollectionViewController : UICollectionViewController {
    
    //Mark: Outlets
    
    @IBOutlet var CustomCollection: UICollectionView!
  
    
    
    //Defining variables and constants
    
    let baseRef = Firebase(url:"https://277roshan.firebaseio.com")
    private let reuseIdentifier = "FlickrCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private var searches = ["Vardy", "Mahrez", "Okazaki", "Schmeichel",  "Kante"]
    private var soccer_images = [UIImage(named: "Vardy"), UIImage(named: "Mahrez"), UIImage(named: "Okazaki"), UIImage(named: "Schmeichel"), UIImage(named: "Kante")]
    let apiKey = "a49c3228fa879647b6e279e8fdcf52b0"
    
    
    override func viewDidLoad() {
    }
    
    @IBAction func LogoutFirebase(sender: AnyObject) {
        baseRef.unauth()
    }
}

//Collection View Part


extension CollectionViewController {
    //1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches.count
    }
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrCell", forIndexPath: indexPath) as! FlickrCellViewController
        
        
        cell.labelOutlet.text = self.searches[indexPath.row]
        cell.imageOutlet.image = self.soccer_images[indexPath.row]
        
        
        // Configure the cell
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("mainview", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "mainview") {
            let svc = segue.destinationViewController as! MainViewController
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView!.indexPathForCell(cell)
            
            svc.image_select = self.soccer_images[(indexPath?.row)!]!
            svc.name_player = self.searches[(indexPath?.row)!]
        }
    }
    
}




