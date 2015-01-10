//
//  AppDelegate.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 25/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?
    var lastBeacons : [CLBeacon]?
    var lastMajor: NSNumber?
    var conferenceJsonGot: Bool = false
    var beaconJsonGot: Bool = false
    var sentNotification: [NSNumber] = []
    var topologyJsonGot: Bool = false
    var mask: CALayer?
    var rootView: UIViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.configureBeacon()
        
        if(application.respondsToSelector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
                    categories: nil
                )
            )
        }
        
        self.rootView = self.window!.rootViewController
        self.mask = CALayer()
        self.mask!.contents = UIImage(named: "SplashMask")!.CGImage
        self.mask!.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.mask!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mask!.position = CGPoint(x: self.window!.frame.size.width/2, y: self.window!.frame.size.height/2)
        rootView!.view.layer.mask = mask
        
        animateMask()
        
        // Override point for customization after application launch.
        self.window!.backgroundColor = UIColor(red: 28/255, green: 98/255, blue: 255/255, alpha: 1)
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: CalendarAfterSegueViewController = storyboard.instantiateViewControllerWithIdentifier("CalendarAfterSegueViewController") as CalendarAfterSegueViewController
        let talk : String = notification.userInfo!["talk"] as String

        viewController.title = talk
        
        self.window!.rootViewController?.presentViewController(viewController, animated: true, completion: nil)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func animateMask() {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self
        keyFrameAnimation.duration = 0.6
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 0.5 //add delay of 1 second
        let initalBounds = NSValue(CGRect: mask!.bounds)
        let secondBounds = NSValue(CGRect: CGRect(x: 0, y: 0, width: 90, height: 90))
        let finalBounds = NSValue(CGRect: CGRect(x: 0, y: 0, width: 1700, height: 1700))
        keyFrameAnimation.values = [initalBounds, secondBounds, finalBounds]
        keyFrameAnimation.keyTimes = [0, 0.3, 0.7]
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        self.mask!.addAnimation(keyFrameAnimation, forKey: "bounds")
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        self.rootView!.view.layer.mask = nil //remove mask when animation completes
    }
    
    func configureBeacon() {
        let uuidString = "3D4F13B4-D1FD-4049-80E5-D3EDCC840B6A"
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

extension AppDelegate: CLLocationManagerDelegate {
    func sendLocalNotificationWithMessage(message: String, playSound: Bool, talk:Talk) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        var userInfo = [String:String]()
        userInfo["talk"] = talk.title
        notification.userInfo = userInfo
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func timerHandler(sender:NSTimer) {
                let beacon:CLBeacon = sender.userInfo as CLBeacon
                for currentBeacon in self.lastBeacons! {
                    if beacon.major == currentBeacon.major && beacon.minor == currentBeacon.minor && beacon.proximity == CLProximity.Immediate {
                        if let roomId: Int = findRoomIdWithMinor(beacon.minor) {
                            if let talk: Talk = findFirstTalkWithRoomId(roomId) {
                                var userInfo = [String:Talk]()
                                userInfo["talk"] = talk
                                sendLocalNotificationWithMessage(talk.title + " - " + talk.abstract, playSound: true, talk: talk)
                            }
                        }
                    }
                }
    }
    
    func findRoomIdWithMinor(minor: NSNumber) -> Int? {
        let beacons: Beacons = Beacons.sharedInstance
        if let beacon:Beacon = beacons.array!.filter({ $0.minor == minor }).first? {
            return beacon.room_id
        }
        return nil
    }
    
    func findFirstTalkWithRoomId(room_id: Int) -> Talk? {
        if let tracks: [Track] = Conference.sharedInstance.tracks {
            for track in tracks {
                let sessions: [Session] = track.sessions
                if let session: Session = sessions.filter({ $0.room_id == room_id }).first? {
                    return session.talks.first
                }
            }
        }
        return nil
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [CLBeacon]!, inRegion region: CLBeaconRegion!) {
        if(beacons.count > 0) {
            if let lastBeacons = self.lastBeacons {
                for beacon in beacons {
                    for prevBeacon in lastBeacons {
                        if beacon.major == prevBeacon.major && beacon.minor == prevBeacon.minor && beacon.proximity == CLProximity.Immediate && !contains(self.sentNotification, beacon.minor) {
                            NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "timerHandler:", userInfo: beacon, repeats: false)
                            self.sentNotification.append(beacon.minor)
                        }
                    }
                }
            }
            self.lastBeacons = beacons
            NSNotificationCenter.defaultCenter().postNotificationName("beaconUpdate", object: nil, userInfo: nil)
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
            manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
            manager.startUpdatingLocation()
            
            NSLog("You entered the region")
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
            manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
            manager.stopUpdatingLocation()
            
            NSLog("You exited the region")
//            sendLocalNotificationWithMessage("You exited the region", playSound: false)
    }
}