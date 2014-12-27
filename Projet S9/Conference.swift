//
//  Conference.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 30/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import Foundation


private let _ConferenceSharedInstance = Conference()

/**
Data entity that represents a conference.
Subclasses NSObject to enable Obj-C instantiation.
*/
class Conference : NSObject, Equatable
{
    var
    id:         Int?,
    address:    String?,
    title:      String?,
    start_day:  String?,
    end_day:    String?,
    major:      Int?,
    created_at: Int?,
    updated_at: Int?,
    tracks:     [Track]?
    
    class var sharedInstance: Conference {
        return _ConferenceSharedInstance
    }
    
    
    // Used by Foundation collections, such as NSSet.
    override func isEqual(object: AnyObject!) -> Bool {
        return self == object as Conference
    }
    
    func setData(id:Int, address:String, title:String, start_day:String, end_day:String, major:Int, created_at:Int, updated_at:Int, tracks:[Track]) {
        self.id = id
        self.address = address
        self.title = title
        self.start_day = start_day
        self.end_day = end_day
        self.major = major
        self.created_at = created_at
        self.updated_at = updated_at
        self.tracks = tracks
    }
    
}

// Required for Equatable protocol conformance
func == (lhs: Conference, rhs: Conference) -> Bool {
    return lhs.id == rhs.id
}