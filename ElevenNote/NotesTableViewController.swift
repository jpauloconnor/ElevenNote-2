//
//  NotesTableViewController.swift
//  ElevenNote
//
//  Created by Brett Keck on 5/31/15.
//  Copyright (c) 2015 Brett Keck. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return NoteStore.sharedInstance.getCount()
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notesCell", forIndexPath: indexPath) as! NoteTableViewCell

        cell.setupCell(NoteStore.sharedInstance.getNote(indexPath.row))

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            NoteStore.sharedInstance.deleteNote(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "editNoteSegue" {
            let noteDetailVC = segue.destinationViewController as! NotesDetailViewController
            let tableCell = sender as! NoteTableViewCell
            noteDetailVC.note = tableCell.note
        }
    }
    
    @IBAction func saveNoteDetail(segue:UIStoryboardSegue) {
        let noteDetailVC = segue.sourceViewController as! NotesDetailViewController
        if let indexPath = tableView.indexPathForSelectedRow() {
//            NoteStore.sharedInstance.updateNote(noteDetailVC.note, index: indexPath.row)
            NoteStore.sharedInstance.sort()
            
            var indexPaths = [NSIndexPath]()
            for index in 0...indexPath.row {
                indexPaths.append(NSIndexPath(forRow: index, inSection: 0))
            }
            
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        } else {
            NoteStore.sharedInstance.addNote(noteDetailVC.note)
            tableView.reloadData()
        }
    }
}









