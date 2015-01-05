//
//  CalendarTableViewController.swift
//  Projet S9
//
//  Created by Guillaume SCHAHL on 05/01/2015.
//  Copyright (c) 2015 Jérémie Foucault. All rights reserved.
//

import Foundation

struct Calendar {
    let session : String
    let start_ts: Int
    let end_ts: Int
    let speaker: String
    let abstract : String
    let body: String
    let title : String
    let room: String
    
    
    init(session: String, start_ts: Int, end_ts:Int, speaker: String, abstract: String, body: String, title: String, room: String){
        self.session    = session;
        self.start_ts   = start_ts;
        self.end_ts     = end_ts;
        self.speaker    = speaker;
        self.abstract   = abstract;
        self.body       = body;
        self.title      = title;
        self.room       = room;
    }
}

class CalendarTableViewController : UITableViewController {
    
    var calendar = [Calendar]()

    @IBOutlet weak var tracksTableView: UITableView! 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myConference: Conference = Conference.sharedInstance
        
        var indexCount: Int = 0;
        var indexTracks: Int = 0;
        var indexSessions: Int = 0;
        var indexTalks: Int = 0;
        
        
        
        // Sample Data for candyArray
        self.calendar = [Calendar(session: "Telecommunication", start_ts: 1421829000, end_ts: 1421830800, speaker: "Hello My name is", abstract: "Quelques challenges en imagerie" , body: "BlablablablaBlablablabla" , title: "Sujet n°1", room: "I002")]
        
        // Reload the table
        self.tableView.reloadData()
    }
    
    //Govern the table view itself
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.calendar.count
    }
    
    
    // Complete each row with the information
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        //let cell = self.tableView.dequeueReusableCellWithIdentifier("CellCalendar", forIndexPath: indexPath) as UITableViewCell
        let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("CellCalendar") as CustomCell
        // Get the corresponding candy from our candies array
        let calendar = self.calendar[indexPath.row]
        
        // Configure the cell
        //cell.textLabel!.text = calendar.title
        //cell.subject.text = calendar.title;
        cell.setCell(calendar.title , room: calendar.room , start_ts: "A", end_ts: "A")
        //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell;
    }



}