//
//  MenuItem.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 13/12/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import Foundation

/**
Data entity that represents a conference.
Subclasses NSObject to enable Obj-C instantiation.
*/
class MenuItem : NSObject
{
    let title:      String,
        identifier: String,
        image:      UIImage
    
    init(
        title:      String,
        identifier: String,
        image:      UIImage)
    {
        self.title      = title
        self.identifier = identifier
        self.image      = image
    }
}
