//
//  Talk.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 30/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import Foundation

/**
Data entity that represents a Talk.
Subclasses NSObject to enable Obj-C instantiation.
*/
class Talk : NSObject, Equatable
{
    let
    id:         Int,
    title:      String,
    start_ts:   Int,
    end_ts:     Int,
    speaker:    String,
    abstract:   String,
    body:       String
    
    init(
        id:         Int,
        title:      String,
        start_ts:   Int,
        end_ts:     Int,
        speaker:    String,
        abstract:   String,
        body:       String)
    {
        self.id         = id
        self.title      = title
        self.start_ts   = start_ts
        self.end_ts     = end_ts
        self.speaker    = speaker
        self.abstract   = abstract
        self.body       = body
    }
    
}

// Required for Equatable protocol conformance
func == (lhs: Talk, rhs: Talk) -> Bool {
    return lhs.id == rhs.id
}