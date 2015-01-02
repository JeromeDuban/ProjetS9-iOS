//
//  BeaconsModelBuilder.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 02/01/2015.
//  Copyright (c) 2015 Jérémie Foucault. All rights reserved.
//

import Foundation



class BeaconsModelBuilder {
    
    class func buildBeaconsFromJSON(beaconsJson: JSON) {
        var beacons: [Beacon] = []
    
        for (index, beaconJson) in beaconsJson {
            let id : Int                    = beaconJson["id"].intValue
            let uuid: String                = beaconJson["uuid"].stringValue
            let major: Int                  = beaconJson["major"].intValue
            let minor: Int                  = beaconJson["minor"].intValue
            let floor_id: Int               = beaconJson["floor_id"].intValue
            let room_id: Int                = beaconJson["room_id"].intValue
            let x: CGFloat                  = CGFloat(beaconJson["coordinates"]["x"].floatValue)
            let y: CGFloat                  = CGFloat(beaconJson["coordinates"]["y"].floatValue)
            let coordinates: CGPoint    = CGPoint(x: x, y: y)

            
            beacons.append(Beacon(
                id: id,
                uuid: uuid,
                major: major,
                minor: minor,
                floor_id: floor_id,
                room_id: room_id,
                coordinates: coordinates
            ))
            
        }
        
        Beacons.sharedInstance.setData(beacons)
    }
    
}