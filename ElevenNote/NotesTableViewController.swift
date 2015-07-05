//
//  NotesTableViewController.swift
//  ElevenNote
//
//  Created by Brett Keck on 5/31/15.
//  Copyright (c) 2015 Brett Keck. All rights reserved.
//

import UIKit

class NotesTableViewController: PFQueryTableViewController, UISearchBarDelegate{
    
    // Sign the user out
    @IBAction func signOut(sender: AnyObject) {
    
        PFUser.logOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpViewController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }

    // Add button
    
    @IBAction func addNote(sender: AnyObject) {
        
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("NotesDetailViewController", sender: self)
            
        }
    }
    //Table search bar

    @IBOutlet weak var searchBar: UISearchBar!
    
    override init(style: UITableViewStyle, className: String!){
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //configure the PFQueryTableView
        self.parseClassName = "Note"
        self.textKey = "title"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! NoteTableViewCell!
        
        if cell == nil {
            cell = NoteTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CustomCell")
        }
        
        //Extract values from the PFObject to display in the the table cell
        
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
        detailScene.currentNote = objects?[row] as? PFObject
       
        }
        }
        
    override func queryForTable() -> PFQuery {
        
        // Start the query object
        var query = PFQuery(className: "Note")
        
        //Add a where clause if there is a search criteria.
        
        if searchBar.text != "" {
            query.whereKey("searchText", containsString: searchBar.text.lowercaseString)
            
        }
        // Order the results
        query.orderByAscending("title")
        
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
    
    
    override func viewDidAppear(animated: Bool) {
        
        // Refresh the table to ensure any data changes are displayed
        tableView.reloadData()
        
        // Delegate the search bar to this table view class
        searchBar.delegate = self

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










//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 1
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return NoteStore.sharedInstance.getCount()
//    }
//
//
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("notesCell", forIndexPath: indexPath) as! NoteTableViewCell
//
//        cell.setupCell(NoteStore.sharedInstance.getNote(indexPath.row))
//
//        return cell
//    }
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return NO if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    
//    // Override to support editing the table view.
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            NoteStore.sharedInstance.deleteNote(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return NO if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "editNoteSegue" {
//            let noteDetailVC = segue.destinationViewController as! NotesDetailViewController
//            let tableCell = sender as! NoteTableViewCell
//            noteDetailVC.note = tableCell.note
//        }
//    }
//    
//    @IBAction func saveNoteDetail(segue:UIStoryboardSegue) {
//        let noteDetailVC = segue.sourceViewController as! NotesDetailViewController
//        if let indexPath = tableView.indexPathForSelectedRow() {
////            NoteStore.sharedInstance.updateNote(noteDetailVC.note, index: indexPath.row)
//            NoteStore.sharedInstance.sort()
//            
//            var indexPaths = [NSIndexPath]()
//            for index in 0...indexPath.row {
//                indexPaths.append(NSIndexPath(forRow: index, inSection: 0))
//            }
//            
//            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
//        } else {
//            NoteStore.sharedInstance.addNote(noteDetailVC.note)
//            tableView.reloadData()
//        }
//    }
//}
//
//
//
//
//
//
//
//
//
