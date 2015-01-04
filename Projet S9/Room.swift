//
//  Rooms.swift
//  Projet S9
//
//  Created by Guillaume SCHAHL on 04/01/2015.
//  Copyright (c) 2015 Jérémie Foucault. All rights reserved.
//

import Foundation

/**
Data entity that represents a Talk.
Subclasses NSObject to enable Obj-C instantiation.
*/
class Room : NSObject, Equatable
{
    let
    id:         Int,
    dom_id:     String,
    name:       String
    
    init(
        id:         Int,
        dom_id:     String,
        name:       String)
    {
        self.id         = id
        self.dom_id     = dom_id
        self.name       = name
    }
    
}

// Required for Equatable protocol conformance
func == (lhs: Room, rhs: Room) -> Bool {
    return lhs.id == rhs.id
}