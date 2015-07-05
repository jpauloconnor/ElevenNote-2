//
//  SignUpViewController.swift
//  ElevenNote
//
//  Created by Paul O'Connor on 7/5/15.
//  Copyright (c) 2015 Brett Keck. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topMessage: UILabel!
    @IBAction func signUp(sender: AnyObject) {
    
            //Build the terms and conditions alert.
        
        let alertController = UIAlertController(title: "Agree to terms and conditions",
            message: "Click I AGREE to signal that you agree to the End User License Agreement.",
            preferredStyle: UIAlertControllerStyle.Alert
        
        )
        alertController.addAction(UIAlertAction(title: "I Agree",
            style: UIAlertActionStyle.Default,
            handler: { alertController in self.processSignUp()})
        
        )
        alertController.addAction(UIAlertAction(title: "I do NOT agree",
            style: UIAlertActionStyle.Default,
            handler: nil)
        )
        
        // Display alert
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func signIn(sender: AnyObject) {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        var userEmailAddress = emailAddress.text
        userEmailAddress = userEmailAddress.lowercaseString
        
        var userPassword = password.text
        
        PFUser.logInWithUsernameInBackground(userEmailAddress, password: userPassword) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.performSegueWithIdentifier("signInSegue", sender: self)
                }
            } else {
                self.activityIndicator.stopAnimating()
                
                if let message: AnyObject = error!userInfo!["error"] {
                    self.message.text = "\(message)"
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        
    }
    
    func processSignUp() {
        
        var userEmailAddress = emailAddress.text
        var userPassword = password.text
        // Ensure that username is lowercase
        userEmailAddress = userEmailAddress.lowercaseString
        
        // Add email address validation
        
        // Start activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        // Create the user
        var user = PFUser()
        user.username = userEmailAddress
        user.password = userPassword
        user.email = userEmailAddress
        
        user.signUpInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("signInSegue", sender: self)
                }
            }else {
                self.activityIndicator.stopAnimating()
                if let topMessage: AnyObject = error!.userInfo!["error"]{
                    self.topMessage.text = "\(topMessage)"
                }
            }
        }
    }
}
