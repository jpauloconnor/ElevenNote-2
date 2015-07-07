//
//  NotesTableViewController.swift
//  ElevenNote
//
//  Created by Paul O'Connor on 5/31/15.
//  Copyright (c) 2015 Brett Keck. All rights reserved.
// Tutorials used: Vea Software, 

import UIKit

class NotesTableViewController: PFQueryTableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UISearchBarDelegate{
 
    var noteObjects: NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    // Sign the user out
//    @IBAction func signOut(sender: AnyObject) {
//    
//        PFUser.logOut()
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("NotesTableViewController") as! UIViewController
//        self.presentViewController(vc, animated: true, completion: nil)
//    }

    // Add button
    
    @IBAction func addNote(sender: AnyObject) {
        
    // Force reload data function to run on the main thread.
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("notesToDetail", sender: self)
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // If there is no user, present a sign up VC & LogInVC

        if (PFUser.currentUser() == nil) { //no current user
            var logInViewController = PFLogInViewController()
            logInViewController.delegate = self
            var signUpViewController = PFSignUpViewController()
            signUpViewController.delegate = self
            logInViewController.signUpController = signUpViewController
            self.presentViewController(logInViewController, animated: true, completion: nil)
            
        } else {
            self.fetchAllObjectsFromLocalDatastore()
            self.fetchAllObjects()
            tableView.reloadData()
            searchBar.delegate = self
        }
        
    }
    func fetchAllObjectsFromLocalDatastore() {
        
        var query: PFQuery = PFQuery(className: "Note")
        query.fromLocalDatastore()
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in  //asynchronous request
            
            if (error == nil) {
                var temp: NSArray = (objects as? NSArray!)!
                //This took forever to figure out.  How do I Fix?  Before it was unwrapping in the console only. Optional("eslkjlkj3")  Getting it like this was an absolute shell game.
                
                self.noteObjects = temp.mutableCopy() as! NSMutableArray
                
                self.tableView.reloadData()
                
                //                //
                ////
                ////                if let objects = objects as? [PFObject]{
                ////                    for object in objects {
                ////                        println(object.objectId)
                //                    }
                //                }
                //
                //                self.tableView.reloadData()
                
            }else{
                println (error!.userInfo)
                
            }
        }
    }

    func fetchAllObjects() {
        
        PFObject.unpinAllObjectsInBackgroundWithBlock(nil) //start fresh.
        var query: PFQuery = PFQuery(className: "Note")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                PFObject.pinAllInBackground(objects, block: nil)
                
            }else{
                
                println(error!.userInfo)
                
            }
        }
    }

    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if (!username.isEmpty || !password.isEmpty) { //Check and make sure fields are not empty
            
            return true //if not empty continue log in
            
        }else{
            
            return false
        }
    }
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        
        println("Failed to log in")
    }
    
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        
        if let password = info["password"] as? String {
            
            return count(password.utf16) >= 8
            
        } else {
            
            return false
        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        
        println("Failed to sign up")
        
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
        println("User dismissed sign up")
        
    }
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

    //Table search bar

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //Initialize the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!){
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //configure the PFQueryTableView
        self.parseClassName = "Note"
        self.textKey = "noteTitle"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("NotesCell") as! NoteTableViewCell!
        
        if cell == nil {
            cell = NoteTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "NotesCell")
        }
        
        //Extract values from the PFObject to display in the table cell
        
        if let noteTitle = object?["noteTitle"] as? String {
            cell.customNoteTitle.text = noteTitle
        }
        
        if let noteText = object?["noteText"] as? String {
            cell.customNoteText.text = noteText
        }
        
        return cell
}
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //get the new view controller using [segue destinationViewController
        var detailScene = segue.destinationViewController as! NotesDetailViewController
        
        // Pass the selected object to the destination view controller.
        
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let row = Int(indexPath.row)
            detailScene.currentObject = objects?[row] as? PFObject
            
        }
    }

    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        
        // Start the query object
        var query = PFQuery(className: "Note")
        
        //Add a where clause if there is a search criteria.
        
        if searchBar.text != "" {
            query.whereKey("searchText", containsString: searchBar.text.lowercaseString)
            
        }
        // Order the results
        query.orderByAscending("noteTitle")
        
        // Return the query object
        return query
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        //Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data.
        self.loadObjects()
    }
        
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data
        self.loadObjects()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        // Clear any search criteria
        searchBar.text = ""
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data
        self.loadObjects()
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Delete the row from the data source
            let objectToDelete = objects?[indexPath.row] as! PFObject
            objectToDelete.deleteInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
            
                    // Force a reload of the table - fetching fresh data from Parse platform
                    self.loadObjects()
                } else {
                    
                    // There was a problem, check error.description
                }
            }

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

}



