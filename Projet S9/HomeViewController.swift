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

    
    var conferences: [Conference] = []
    var locationManager: CLLocationManager?
    var lastMajor: NSNumber?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var startDayLabel: UILabel!
    @IBOutlet weak var endDayLabel: UILabel!
    
    override func viewDidLoad() {
        super.unwindSegueIdentifier = "homeUnwindSegueToMenu"
        super.viewDidLoad()

        self.configureBeacon()
        self.getConferencesFromAPI()
        
        navigationItem.title = "Home"
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func getConferencesFromAPI() {
        let url = URLFactory.allConferences()
        JSONService
            .GET(url)
            .success{json in {self.makeConferences(json)} ~> { self.conferences = $0 }}
            .failure(onFailure, queue: NSOperationQueue.mainQueue())
    }
    
    private func makeConferences(json: AnyObject) -> [Conference] {
        let jsonParsed: JSON = JSON(json)
        if let conferences = ModelBuilder.buildConferencesFromJSON(jsonParsed) as? [Conference] {
            if let unique = NSSet(array: conferences).allObjects as? [Conference] {
                return unique.sorted { $0.title < $1.title }
            }
        }
        return []
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
    
    
    
    func findConferenceWithMajor(major: NSNumber) -> Conference {
        println(major)
        return self.conferences.filter({$0.major == major}).first!
    }
    
    func configureBeacon() {
        let uuidString = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"
        let beaconIdentifier = "eirBeacon"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
            identifier: beaconIdentifier)
        
        locationManager = CLLocationManager()
        
        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager!.requestAlwaysAuthorization()
        }
        
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        locationManager!.startUpdatingLocation()
    }

}

extension HomeViewController: CLLocationManagerDelegate {
    func sendLocalNotificationWithMessage(message: String, playSound: Bool) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    func locationManager(manager: CLLocationManager!,
        didRangeBeacons beacons: [AnyObject]!,
        inRegion region: CLBeaconRegion!) {
            
            var message:String = ""
            let dataManager = DataManager()
            
            if(beacons.count > 0) {
                let nearestBeacon:CLBeacon = beacons[0] as CLBeacon
                NSLog("Beacons detected, major: \(nearestBeacon.major.intValue)")
                
                if(nearestBeacon.major == lastMajor ||
                    nearestBeacon.proximity == CLProximity.Unknown) {
                        return;
                }
                NSLog("New major detected")
                
                if (self.conferences.count > 0 ){
                    lastMajor = nearestBeacon.major;
                    let myConference : Conference = findConferenceWithMajor(lastMajor!)
                    titleLabel.text = myConference.title
                    addressLabel.text = myConference.address
                    startDayLabel.text = myConference.start_day
                    endDayLabel.text = myConference.end_day
                }

                
            } else {
                NSLog("No beacons are nearby")
            }
            
            NSLog("%@", message)
    }

    func locationManager(manager: CLLocationManager!,
        didEnterRegion region: CLRegion!) {
            manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
            manager.startUpdatingLocation()
            
            NSLog("You entered the region")
            sendLocalNotificationWithMessage("You entered the region", playSound: false)
    }

    func locationManager(manager: CLLocationManager!,
        didExitRegion region: CLRegion!) {
            manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
            manager.stopUpdatingLocation()
            
            NSLog("You exited the region")
            sendLocalNotificationWithMessage("You exited the region", playSound: false)
    }
}

