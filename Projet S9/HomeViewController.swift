//
//  HomeViewController.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 25/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: BaseViewController, UIBarPositioningDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var startDayLabel: UILabel!
    @IBOutlet weak var endDayLabel: UILabel!
    @IBOutlet weak var conferenceSubView: UIView!
    @IBOutlet weak var noConferenceSubView: UIView!
    
    let app:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.unwindSegueIdentifier = "homeUnwindSegueToMenu"
        super.viewDidLoad()

        self.getConferencesFromAPI()
        self.getBeaconsFromAPI()
        self.getTopologyFromAPI()
        self.conferenceSubView.hidden = true
        if app.lastBeacons?.count > 0 {
            self.updateData()
            self.conferenceSubView.hidden = false
            self.noConferenceSubView.hidden = true
        }
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
        }

    }
    
    private func getConferencesFromAPI() {
        let url = URLFactory.conferenceWithMajorAPI(10)
        JSONService
            .GET(url)
            .success{json in {self.makeConference(json)} ~> { self.app.conferenceJsonGot = true;}}
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
    
    
}