//
//  Topology.swift
//  Projet S9
//
//  Created by Guillaume SCHAHL on 04/01/2015.
//  Copyright (c) 2015 Jérémie Foucault. All rights reserved.
//

import Foundation


private let _TopologySharedInstance = Topology()

/**
Data entity that represents a topologys.
Subclasses NSObject to enable Obj-C instantiation.
*/
class Topology : NSObject, Equatable
{
    var
    major:      Int?,
    name:       String?,
    link:       String?,
    floors:      [Floor]?
    
    class var sharedInstance: Topology {
        return _TopologySharedInstance
    }
    
    
    // Used by Foundation collections, such as NSSet.
    override func isEqual(object: AnyObject!) -> Bool {
        return self == object as Topology
    }
    
    func setData(major:Int, name:String, link:String, floors:[Floor]) {
        self.major = major
        self.name = name
        self.link = link
        self.floors = floors
    }
    

    
}

// Required for Equatable protocol conformance
func == (lhs: Topology, rhs: Topology) -> Bool {
    return lhs.major == rhs.major
}