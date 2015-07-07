//
//  NotesDetailViewController.swift
//  ElevenNote
//
//  Created by Brett Keck on 5/31/15.
//  Copyright (c) 2015 Brett Keck. All rights reserved.
//
//
import UIKit

class NotesDetailViewController: UIViewController {
   
    
    // Container to store the view table selected object
    var currentObject : PFObject?

    // Some text fields.
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteText: UITextView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //The save button

    @IBAction func saveButton(sender: UIBarButtonItem) {
        if let updateObject = currentObject as PFObject? {
            
            // Update the existing Parse object
            updateObject["noteTitle"] = noteTitle.text
            updateObject["noteText"] = noteText.text
            
            // Create a string of text that is used by search capabilities.
            
            var searchText = (noteTitle.text + " " + noteText.text + " ").lowercaseString
            updateObject["searchText"] = searchText
            updateObject.saveEventually()
            
            
        } else {
            // Create a new parse object.
            var updateObject = PFObject(className: "Note")
            
            updateObject["noteTitle"] = noteTitle.text
            updateObject["noteText"] = noteText.text
            
            
            //Create a string of text that is used by search capabilities.
            var searchText = (noteTitle.text + " " + noteText.text + " ").lowercaseString
            updateObject["searchText"] = searchText
            
            // This makes the user's info private. 
            
            updateObject.ACL = PFACL(user: PFUser.currentUser()!)
            
            //Save the data back to the server in a background task.
            updateObject.saveEventually()
            
        }
        //Return to table view.
     self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Unwrap the current object object
        
        if let object = currentObject {
            
            noteTitle.text = object["noteTitle"] as! String
            noteText.text = object["noteText"] as! String
            
        }
    }

}

