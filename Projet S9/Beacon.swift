//
//  Beacon.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 02/01/2015.
//  Copyright (c) 2015 Jérémie Foucault. All rights reserved.
//

import Foundation

class Beacon : NSObject, Equatable
{
    let
    id:             Int,
    uuid:           String,
    major:          Int,
    minor:          Int,
    floor_id:       Int,
    room_id:        Int,
    coordinates:    CGPoint
    
    
    init(
        id:             Int,
        uuid:           String,
        major:          Int,
        minor:          Int,
        floor_id:       Int,
        room_id:        Int,
        coordinates:    CGPoint)
    {
        self.id             = id
        self.uuid           = uuid
        self.major          = major
        self.minor          = minor
        self.floor_id       = floor_id
        self.room_id        = room_id
        self.coordinates    = coordinates
    }
    
}

// Required for Equatable protocol conformance
func == (lhs: Beacon, rhs: Beacon) -> Bool {
    return lhs.id == rhs.id
}