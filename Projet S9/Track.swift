//
//  Track.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 30/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import Foundation

/**
Data entity that represents a Track.
Subclasses NSObject to enable Obj-C instantiation.
*/
class Track : NSObject, Equatable
{
    let
    id:         Int,
    title:      String,
    sessions:   [Session]
    
    
    init(
        id:         Int,
        title:      String,
        sessions:   [Session])
    {
        self.id         = id
        self.title      = title
        self.sessions   = sessions
    }

}

// Required for Equatable protocol conformance
func == (lhs: Track, rhs: Track) -> Bool
{
    return lhs.id == rhs.id
}