//
//  NoteTableViewCell.swift
//  ElevenNote
//
//  Created by Brett Keck on 5/31/15.
//  Copyright (c) 2015 Brett Keck. All rights reserved.
//

import UIKit

class NoteTableViewCell: PFTableViewCell {
    
    @IBOutlet weak var customNoteTitle: UILabel!
    
    @IBOutlet weak var customNoteText: UILabel!
    
    @IBOutlet weak var noteDate: UILabel!


    weak var note : Note!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpCell (note : Note) {
        self.note = note
        customNoteTitle.text = note.title
        customNoteText.text = note.text
        
    }
    
}


