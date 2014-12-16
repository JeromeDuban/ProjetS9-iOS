//
//  iBeaconManager.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 28/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var lastMajor: NSNumber?
    
    func configure() {
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