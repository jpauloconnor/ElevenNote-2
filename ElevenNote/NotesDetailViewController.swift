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
    var currentObject: PFObject?

    // Some text fields.
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let object = currentObject {
            
            noteTitle.text = object["title"] as? String
            noteText.text = object["text"] as? String
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //The save button

    @IBAction func saveButton(sender: UIBarButtonItem) {
        if let updateObject = currentObject as PFObject? {
            
            // Update the existing Parse object
            updateObject["title"] = noteTitle.text
            updateObject["text"] = noteText.text
            
            // Create a string of text that is used by search capabilities.
            
            var searchText = (noteTitle.text + " " + noteText.text + " ").lowercaseString
            updateObject["searchText"] = searchText
            updateObject.saveEventually(nil)
            
            
        } else {
            var updateObject = PFObject(className: "Note")
            
            updateObject["title"] = noteTitle.text
            updateObject["text"] = noteText.text
            
            var searchText = (noteTitle.text + " " + noteText.text + " ").lowercaseString
            updateObject["searchText"] = searchText
            
            updateObject.ACL = PFACL(user: PFUser.currentUser()!)
            updateObject.saveEventually(nil)
            
        }
    
     self.navigationController?.popToRootViewControllerAnimated(true)
    }




//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        noteTitle.text = note.title
//        noteText.text = note.text
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        note.title = noteTitle.text
//        note.text = noteText.text
//        note.date = NSDate()
//    }
//
//}
}