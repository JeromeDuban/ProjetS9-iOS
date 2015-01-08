//
//  CalendarTableViewController .swift
//  Projet S9
//
//  Created by Guillaume SCHAHL on 07/01/2015.
//  Copyright (c) 2015 Jérémie Foucault. All rights reserved.
//

import Foundation


class CalendarTableViewControllerBis : BaseViewController, UITableViewDelegate,UITableViewDataSource   {


    @IBOutlet weak var tableView: UITableView!

    var calendar = [Calendar]()
    var calendarOrder = [Calendar]()

    
    
    override func viewDidLoad() {
        super.unwindSegueIdentifier = "calendarUnwindSegueToMenu"
        super.viewDidLoad()
 
        navigationItem.title = "Calendar"
       // self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //var nib = UINib(nibName: "CustomCell", bundle: nil);

        
        //self.tableView.registerClass(CustomCell.self, forCellReuseIdentifier: "CellCalendarBis")
        
        
        
        let myConference: Conference = Conference.sharedInstance
        
        var indexCount: Int = 0;
        var indexTracks: Int = 0;
        var indexSessions: Int = 0;
        var indexTalks: Int = 0;
        //calendar = [];
        
        

        if(myConference.tracks?.count != nil){
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
        }
        calendarOrder = calendar.sorted({ $0.start_ts < $1.start_ts})
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calendar.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell

        var cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("CellCalendarBis", forIndexPath: indexPath) as CustomCell
        //cell.textLabel?.text = self.items[indexPath.row]

        let calendar = self.calendarOrder[indexPath.row]

        //cell.setCell( calendar.title, room: "Room n°"  , start_ts: "", end_ts: "", color: UIColor.greenColor())
        cell.setCell(calendar.title , room: "Room n°" + calendar.room , start_ts: getTime(calendar.start_ts), end_ts: getTime(calendar.end_ts), color: UIColor.greenColor())
        //cell.setCellBis(self.items[indexPath.row])
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        
        return cell
    }
    

    
    func getTime(var date: Int)-> String{
        var respondedDate = Double(date);
        var date = NSDate(timeIntervalSince1970: respondedDate);
        let calendarBis = NSCalendar.currentCalendar()
        let comp = calendarBis.components((.HourCalendarUnit | .MinuteCalendarUnit), fromDate: date)
        let hour = comp.hour
        let minute = comp.minute
        
        
        return String(hour) + "h" + String(minute);
    }
    
    func getRandomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("calendarDetail", sender: tableView)
    }
    
    @IBOutlet var titleSegue: NSLayoutConstraint!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "calendarDetail" {
            let calendarDetailViewController = segue.destinationViewController as UIViewController
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let destinationTitle = self.calendarOrder[indexPath.row].title;
            calendarDetailViewController.title = destinationTitle
            
            
            
            
        }
    }
    


}