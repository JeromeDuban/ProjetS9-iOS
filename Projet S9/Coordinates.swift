//
//  Coordiates.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 02/01/2015.
//  Copyright (c) 2015 Jérémie Foucault. All rights reserved.
//

import Foundation


class Coordinates : NSObject, Equatable
{
    let
    x:    Float,
    y:    Float
    
    init(
        x:     Float,
        y:     Float)
    {
        self.x   = x
        self.y   = y
    }
    
}

// Required for Equatable protocol conformance
func == (lhs: Coordinates, rhs: Coordinates) -> Bool {
    return (lhs.x == rhs.x) && (lhs.y == rhs.y)
}