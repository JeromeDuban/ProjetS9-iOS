//
//  HomeViewController.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 25/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, UIGestureRecognizerDelegate, UIBarPositioningDelegate, CLLocationManagerDelegate {

    
    var conferences: [Conference] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.slidingViewController().panGesture.delegate = self
        
        self.view.addGestureRecognizer(self.slidingViewController().panGesture)

        self.getConferencesFromAPI()
    }
    

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer!) -> Bool {
        if (gestureRecognizer.locationInView(gestureRecognizer.view).x < 30.0) {
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func getConferencesFromAPI() {
        let url = URLFactory.allConferences()
        JSONService
            .GET(url)
            .success{json in {self.makeConferences(json)} ~> {
                self.conferences = $0
                self.logConferences(self.conferences)
            }}
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
    
    private func logConferences(conferences: [Conference]) {
        NSLog("Conference id: \(conferences[0].id)\n Title: \(conferences[0].title)")
        let tmp: NSNumber = 10
        NSLog("Bla : "+self.findConferenceWithMajor(tmp).title)
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
        return self.conferences.filter({$0.major == major}).first!
    }

}

//extension BeaconManager: CLLocationManagerDelegate {
//    func sendLocalNotificationWithMessage(message: String!, playSound: Bool) {
//        let notification:UILocalNotification = UILocalNotification()
//        notification.alertBody = message
//        
//        UIApplication.sharedApplication().scheduleLocalNotification(notification)
//    }
//    
//    func locationManager(manager: CLLocationManager!,
//        didRangeBeacons beacons: [AnyObject]!,
//        inRegion region: CLBeaconRegion!) {
//            //            let viewController:ViewController = window!.rootViewController as ViewController
//            //            viewController.beacons = beacons as [CLBeacon]?
//            //            viewController.tableView!.reloadData()
//            
//            NSLog("didRangeBeacons")
//            var message:String = ""
//            let dataManager = DataManager()
//            
//            if(beacons.count > 0) {
//                let nearestBeacon:CLBeacon = beacons[0] as CLBeacon
//                
//                if(nearestBeacon.major == lastMajor ||
//                    nearestBeacon.proximity == CLProximity.Unknown) {
//                        return;
//                }
//                lastMajor = nearestBeacon.major;
//                dataManager.getConference(lastMajor!)
//                
//            } else {
//                NSLog("No beacons are nearby")
//            }
//            
//            NSLog("%@", message)
//    }
//    
//    func locationManager(manager: CLLocationManager!,
//        didEnterRegion region: CLRegion!) {
//            manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
//            manager.startUpdatingLocation()
//            
//            NSLog("You entered the region")
//    }
//    
//    func locationManager(manager: CLLocationManager!,
//        didExitRegion region: CLRegion!) {
//            manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
//            manager.stopUpdatingLocation()
//            
//            NSLog("You exited the region")
//    }
//}

