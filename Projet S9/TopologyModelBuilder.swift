//
//  TopologyModelBuilder.swift
//  Projet S9
//
//  Created by Guillaume SCHAHL on 04/01/2015.
//  Copyright (c) 2015 Jérémie Foucault. All rights reserved.
//

import Foundation


class TopologyModelBuilder {
    
    
    class func buildTopologyFromJSON(topologyJson: JSON) {
        let major: Int                  = topologyJson["major"].intValue
        let name: String                = topologyJson["name"].stringValue
        let link: String                = topologyJson["link"].stringValue
        let floors: [Floor]            = self.buildFloorsFromJSON(topologyJson["floors"])
        
        
        Topology.sharedInstance.setData(
            major,
            name: name,
            link: link,
            floors: floors
        )
    }
        
        class func buildFloorsFromJSON(floorsJson: JSON) -> [Floor] {
            var floors: [Floor] = [];
            
            for (index, floorsJson) in floorsJson {
                let id : Int            = floorsJson["id"].intValue
                let name: String       = floorsJson["name"].stringValue
                let rooms: [Room] = self.buildRoomsFromJSON(floorsJson["rooms"])
                
                floors.append(Floor(id: id, name: name, rooms: rooms))
                
            }
            
            return floors
        }
    
    
    class func buildRoomsFromJSON(roomsJson: JSON) -> [Room] {
        var rooms: [Room] = [];
        
        for (index, roomsJson) in roomsJson {
            let id : Int            = roomsJson["id"].intValue
            let dom_id: String       = roomsJson["dom_id"].stringValue
            let name: String       = roomsJson["name"].stringValue

            
            rooms.append(Room(id: id, dom_id: dom_id, name: name))
            
        }
        
        return rooms
    }
    
    
    
}