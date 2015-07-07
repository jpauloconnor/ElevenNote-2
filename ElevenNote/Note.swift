//
//  Note.swift
//  ElevenNote
//
//  Created by Paul O'Connor on 7/6/15.
//  Copyright (c) 2015 Brett Keck. All rights reserved.
//

import UIKit


class Note: PFObject, PFSubclassing {
    class func parseClassName() -> String {
        return "Note"
    }
//    class var sharedInstance : Note {
//        return NoteStoreInstance
//    }
//    var title : String {
//        get {
//            return objectForKey("title") as! String
//        }
//        set {
//            setObject(newValue, forKey: "title")
//        }
//    }
//    var text : String {
//        get {
//            return objectForKey("text") as! String
//        }
//        set {
//            setObject(newValue, forKey: "text")
//        }
//    }
    @NSManaged var title : String
    @NSManaged var text : String
    @NSManaged var user : PFUser
    @NSManaged var date : NSDate

}



