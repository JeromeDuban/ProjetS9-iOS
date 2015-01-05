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
        
        
        
//        // Sample Data for candyArray
//        self.calendar = [Calendar(session: "Telecommunication", start_ts: 1421829000, end_ts: 1421830800, speaker: "Hello My name is", abstract: "Quelques challenges en imagerie" , body: "BlablablablaBlablablabla" , title: "Sujet n°1", room: "I002")]
        
        
        // Loop for tracks
        while(indexTracks  != myConference.tracks?.count){
            // Loop for sessions
            while(indexSessions != myConference.tracks![indexTracks].sessions.count){
                // Loop for talks

                while(indexTalks != myConference.tracks![indexTracks].sessions[indexSessions].talks.count){
                    // Insert talks
                    
                    let session: Int = myConference.tracks![indexTracks].sessions[indexSessions].id
                    let start_ts: Int = myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].start_ts
                    let end_ts: Int = myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].end_ts
                    let speaker: String = myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].speaker
                    let abstract : String = myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].abstract
                    let body: String = myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].body
                    let title : String = myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].title
                    let room: String = String(myConference.tracks![indexTracks].sessions[indexSessions].room_id)
                    
                    self.calendar.insert(Calendar(session: String(session), start_ts: start_ts, end_ts: end_ts, speaker: speaker, abstract: abstract, body: body, title: title, room: room) , atIndex: indexCount);
                    
                    indexCount += 1;
                    indexTalks += 1;
                    
                }
                indexSessions += 1;
                indexTalks = 0;
                
            }
            
            indexSessions = 0;
            indexTracks += 1;
            
        }
        
        

        
        // Reload the table
        self.tableView.reloadData()
    }
    
    //Govern the table view itself
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.calendar.count
    }
    
    
    // Complete each row with the information
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("CellCalendar") as CustomCell
        // Get the corresponding candy from our candies array
        
        let calendar = self.calendar[indexPath.row]
        
        
        
        
        // Configure the cell
        cell.setCell(calendar.title , room: "Room n°" + calendar.room , start_ts: String(calendar.start_ts), end_ts: String(calendar.end_ts))
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell;
    }
    
    
    
        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            self.performSegueWithIdentifier("calendarDetail", sender: tableView)
        }
    
    @IBOutlet var titleSegue: NSLayoutConstraint!
    
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
            if segue.identifier == "calendarDetail" {
                let calendarDetailViewController = segue.destinationViewController as UIViewController
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = self.calendar[indexPath.row].title
                calendarDetailViewController.title = destinationTitle
                

                
                
            }
        }



}