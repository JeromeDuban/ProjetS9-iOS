//
//  HomeViewController.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 25/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation


class HomeViewController: BaseViewController, UIBarPositioningDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var startDayLabel: UILabel!
    @IBOutlet weak var endDayLabel: UILabel!
    @IBOutlet weak var conferenceSubView: UIView!
    @IBOutlet weak var noConferenceSubView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarSubView: UIView!
    
    //var items: [String] = ["We", "Heart", "Swift"]
    var talk = [Talk]()
    var after = [Talk]();
    
    var myColor: UIColor = UIColor();
    
    let app:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.unwindSegueIdentifier = "homeUnwindSegueToMenu"
        super.viewDidLoad()

        self.getConferencesFromAPI()
        self.getBeaconsFromAPI()
        self.getTopologyFromAPI()
        self.conferenceSubView.hidden = true
        self.calendarSubView.hidden = true
        if app.lastBeacons?.count > 0 {
            self.updateData()
            self.conferenceSubView.hidden = false
            self.noConferenceSubView.hidden = true
            self.calendarSubView.hidden = false
            myColor = getRandomColor();
            self.newFindClosestDates();
            self.tableView.reloadData();
        }
        

        //let myConference: Conference = Conference.sharedInstance
        //println(myConference.tracks?.count)
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.title = "Home"
        
        
    }
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleBeaconsUpdate", name: "beaconUpdate", object: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func handleBeaconsUpdate() {
        let nearestBeacon:CLBeacon = app.lastBeacons![0] as CLBeacon
        if(nearestBeacon.major == app.lastMajor || nearestBeacon.proximity == CLProximity.Unknown) {
                return;
        }
        if (self.app.conferenceJsonGot == true) {
            self.app.lastMajor = nearestBeacon.major
        }
        self.updateData()
        self.conferenceSubView.hidden = false
        self.noConferenceSubView.hidden = true
    }
    
    func updateData() {
        let myConference: Conference = Conference.sharedInstance
        if (self.app.conferenceJsonGot == true) {
            titleLabel.text = myConference.title
            addressLabel.text = myConference.address
            startDayLabel.text = myConference.start_day
            endDayLabel.text = myConference.end_day
            if self.app.upCommingTalks == false {
                self.calendarSubView.hidden = false
                myColor = getRandomColor();
                self.newFindClosestDates();
                self.tableView.reloadData();
                self.app.upCommingTalks = true
            }
        }

    }
    
    private func getConferencesFromAPI() {
        let url = URLFactory.conferenceWithMajorAPI(10)
        JSONService
            .GET(url)
            .success{json in {self.makeConference(json)} ~> {
                self.app.conferenceJsonGot = true
                
            }}
            .failure(onFailure, queue: NSOperationQueue.mainQueue())
    }
    
    private func makeConference(json: AnyObject) {
        let jsonParsed: JSON = JSON(json)
        ConferenceModelBuilder.buildConferenceFromJSON(jsonParsed)
    }

    
    private func getBeaconsFromAPI() {
        let url = URLFactory.beaconsAPI()
        JSONService
            .GET(url)
            .success{json in {self.makeBeacons(json)} ~> { self.app.beaconJsonGot = true;}}
            .failure(onFailure, queue: NSOperationQueue.mainQueue())
    }
    
    private func makeBeacons(json: AnyObject) {
        let jsonParsed: JSON = JSON(json)
        BeaconsModelBuilder.buildBeaconsFromJSON(jsonParsed)
    }
    
    
    
    private func getTopologyFromAPI() {
        let url = URLFactory.buildingWithMajorAPI(10)
        JSONService
            .GET(url)
            .success{json in {self.makeTopology(json)} ~> { self.app.topologyJsonGot = true;}}
            .failure(onFailure, queue: NSOperationQueue.mainQueue())
    }
    
    private func makeTopology(json: AnyObject) {
        let jsonParsed: JSON = JSON(json)
        TopologyModelBuilder.buildTopologyFromJSON(jsonParsed)
    }

    
    private func onFailure(statusCode: Int, error: NSError?)
    {
        println("HTTP status code \(statusCode)")
        
        let
        title = "Error",
        msg   = error?.localizedDescription ?? "An error occurred.",
        alert = UIAlertController(
            title: title,
            message: msg,
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: { _ in
                self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    

    //TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: CustomCellHomeView = self.tableView.dequeueReusableCellWithIdentifier("cellHomeView") as CustomCellHomeView
        //cell.textLabel?.text = self.items[indexPath.row]
                //cell.setCell( calendar.title, room: "Room n°"  , start_ts: "", end_ts: "", color: UIColor.greenColor())
        if (after.count != 0){
            let talks = self.after[indexPath.row]
            cell.setCell(talks.title, start_ts: getTime(talks.start_ts), end_ts: getTime(talks.end_ts), abstract: talks.abstract, barColor: myColor)
        }
        
        
        //cell.setCellBis(self.items[indexPath.row])
        //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        
        return cell
    }
    
    func getTime(var date: Int)-> String{
        var respondedDate = Double(date);
        var date = NSDate(timeIntervalSince1970: respondedDate);
        let formater: NSDateFormatter = NSDateFormatter()
        formater.dateFormat = "H:mm"
        let startTime = formater.stringFromDate(date)
        
        return startTime;
    }
    
    func newFindClosestDates(){
        
        let myConference: Conference = Conference.sharedInstance

        var indexCount: Int = 0;
        var indexTracks: Int = 0;
        var indexSessions: Int = 0;
        var indexTalks: Int = 0;
        var indexFloors: Int = 0;
        var indexRooms: Int = 0;
        
        var indexCountSection: Int = 0;
        var indexCountTalk: Int = 0;
        var indexCountRoom: Int = 0;
        var indexCountTrack: Int = 0;
        // Load the element in the tableview
        
        
        if(myConference.tracks?.count != nil){
            // Loop for tracks
            indexTracks = 0
            while(indexTracks  != myConference.tracks?.count){
                // Loop for sessions
                indexSessions = 0
                while(indexSessions != myConference.tracks![indexTracks].sessions.count){
                    // Loop for talks
                    indexTalks = 0
                    while(indexTalks != myConference.tracks![indexTracks].sessions[indexSessions].talks.count){
                        // Insert talks
                        self.talk.insert(Talk(id: myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].id, title: myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].title, start_ts: myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].start_ts, end_ts: myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].end_ts, speaker:myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].speaker, abstract: myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].abstract, body: myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].body), atIndex: indexCount);



                        indexCount += 1;
                        indexTalks += 1;
                    }
                    indexSessions += 1;
                }
                indexTracks += 1;
                
            }
        }
        
        talk = talk.sorted({ $0.start_ts < $1.start_ts})
        //Test Date
//        let responseInitialDate = Double(1421832450)
//        var date = NSDate(timeIntervalSince1970: responseInitialDate)
        var indexDate = 0;
        
        for(var indexTalks = 0; indexTalks < talk.count; indexTalks++) {
            var tar = talk[indexTalks];
            let date = NSDate()
            var respondedDate = Double(tar.start_ts);
            var dateTest = NSDate(timeIntervalSince1970: respondedDate);

            if (dateTest.laterDate(date) != date){
                self.after.insert(talk[indexTalks], atIndex: indexDate);
                indexDate += 1;
            }

        }
        
        after = after.sorted({ $0.start_ts < $1.start_ts})
        

        
        
    }
    
    func getRandomColor() -> UIColor {
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    

}




