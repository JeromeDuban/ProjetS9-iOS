//
//  Session.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 30/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import Foundation

/**
Data entity that represents a Session.
Subclasses NSObject to enable Obj-C instantiation.
*/
class Session : NSObject, Equatable
{
    let
    id:         Int,
    start_ts:   Int,
    end_ts:     Int,
    room_id:    Int,
    talks:      [Talk]
    
    
    init(
        id:         Int,
        start_ts:   Int,
        end_ts:     Int,
        room_id:    Int,
        talks:      [Talk])
    {
        self.id         = id
        self.start_ts   = start_ts
        self.end_ts     = end_ts
        self.room_id    = room_id
        self.talks      = talks
    }
}

// Required for Equatable protocol conformance
func == (lhs: Session, rhs: Session) -> Bool
{
    return lhs.id == rhs.id
}