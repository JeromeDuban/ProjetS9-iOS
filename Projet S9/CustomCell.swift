//
//  CustomCell.swift
//  Projet S9
//
//  Created by Guillaume SCHAHL on 05/01/2015.
//  Copyright (c) 2015 Jérémie Foucault. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    
//    @IBOutlet var subject: UILabel!
//    @IBOutlet var room: UILabel!
//    @IBOutlet var start_ts: UILabel!
//    @IBOutlet var end_ts: UILabel!
//    @IBOutlet var verticalBar: UIVisualEffectView!
    
    @IBOutlet var toto: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setCell(subject: String, room: String, start_ts: String, end_ts: String, color: UIColor){
//        self.subject.text   = subject;
//        self.room.text      = room;
//        self.start_ts.text  = start_ts;
//        self.end_ts.text    = end_ts;
//        self.verticalBar.backgroundColor = color;
//        self.end_ts.textColor = UIColor.grayColor()
//        self.room.textColor = UIColor.grayColor()

    }
    
    func setCellBis(subject: String){
        self.toto.text = subject
        
    }
    

}
