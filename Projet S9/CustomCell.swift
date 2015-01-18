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
    

//    @IBOutlet weak var start_ts: UILabel!
//    @IBOutlet weak var end_ts: UILabel!
//    @IBOutlet weak var verticalBar: UIVisualEffectView!
//    
//    @IBOutlet weak var subject: UILabel!
//    @IBOutlet weak var room: UILabel!

    @IBOutlet weak var end_ts: UILabel!
    @IBOutlet weak var start_ts: UILabel!
    
    @IBOutlet weak var subject: UILabel!
    
    @IBOutlet weak var verticalBar: UIView!
    @IBOutlet weak var room: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setCell(subject: String, room: String, start_ts: String, end_ts: String, color: UIColor){
        self.subject.text   = subject;
        self.room.text      = room;
        self.start_ts.text  = start_ts;
        self.end_ts.text    = end_ts;
        self.verticalBar.backgroundColor = color;
        self.end_ts.textColor = UIColor.grayColor()
        self.room.textColor = UIColor.grayColor()

    }
    
    func setCellBis(subject: String){
        self.subject.text = subject
        
    }
    

}


class CustomCellHomeView: UITableViewCell {
    
    
    
    
    @IBOutlet weak var subject: UILabel!
    
    @IBOutlet weak var barColor: UIView!
    @IBOutlet weak var end_ts: UILabel!
    @IBOutlet weak var abstract: UILabel!
    @IBOutlet weak var start_ts: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setCell(subject: String,start_ts: String, end_ts: String, abstract: String, barColor: UIColor){
        self.subject.text   = subject;
        self.start_ts.text  = start_ts;
        self.abstract.text   = abstract;
        self.end_ts.text  = end_ts;
        self.barColor.backgroundColor   = barColor;
        
        
    }
    
    
    
}


