//
//  LoginController.swift
//  CollectionView_Roshan
//
//  Created by Roshan Thapaliya on 4/29/16.
//  Copyright © 2016 Roshan Thapaliya. All rights reserved.
//
import UIKit
import Firebase

class LoginController: UIViewController{
    
    
    //Defining constants
    let ref = Firebase(url: "https://277roshan.firebaseio.com")
    
    //Mark: Outlets
    
    @IBOutlet var UserName: UITextField!
    
    @IBOutlet var Password: UITextField!
    
    
    override func viewDidLoad() {
        ref.observeAuthEventWithBlock({ authData in
            if authData != nil {
                // user authenticated
                print(authData)
                self.performSegueWithIdentifier("afterlogin", sender: self)
            } else {
                // No user is signed in
            }
        })
    }

   
    //Mark: Actions
    
    @IBAction func SignUpAction(sender: AnyObject) {
        
        let user_name = UserName.text
        let password = Password.text
        
        ref.createUser(user_name, password: password,
            withValueCompletionBlock: { error, result in
                if error != nil {
                    // There was an error creating the account
                } else {
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid)")
                }
        })
    }
    
    
    @IBAction func LoginAction(sender: AnyObject) {
        
        let user_name = UserName.text
        let password = Password.text
        
        ref.authUser(user_name, password: password) {
            error, authData in
            if error != nil {
                // an error occured while attempting login
            } else {
                // user is logged in, check authData for data
                print(authData)
                self.performSegueWithIdentifier("afterlogin", sender: self)
            }
        }
    }

 
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) { }
}