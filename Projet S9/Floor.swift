//
//  Floors.swift
//  Projet S9
//
//  Created by Guillaume SCHAHL on 04/01/2015.
//  Copyright (c) 2015 Jérémie Foucault. All rights reserved.
//

import Foundation

/**
Data entity that represents a Session.
Subclasses NSObject to enable Obj-C instantiation.
*/
class Floor : NSObject, Equatable
{
    let
    id:         Int,
    name:       String,
    rooms:      [Room]
    
    
    init(
        id:         Int,
        name:       String,
        rooms:      [Room])
    {
        self.id         = id
        self.name       = name
        self.rooms      = rooms
    }
}

// Required for Equatable protocol conformance
func == (lhs: Floor, rhs: Floor) -> Bool {
    return lhs.id == rhs.id
}