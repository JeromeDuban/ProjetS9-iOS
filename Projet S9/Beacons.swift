//
//  Beacons.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 02/01/2015.
//  Copyright (c) 2015 Jérémie Foucault. All rights reserved.
//

import Foundation

private let _BeaconsSharedInstance = Beacons()


class Beacons : NSObject {
    var
    array:     [Beacon]?
    
    class var sharedInstance: Beacons {
        return _BeaconsSharedInstance
    }
    
    func setData(array:[Beacon]) {
        self.array = array
    }
    
}
