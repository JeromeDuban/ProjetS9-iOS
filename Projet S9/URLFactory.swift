//
//  URLFactory.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 30/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import Foundation

/** Builds the URLs needed to call Web services. */
class URLFactory {
    
    class func conferenceWithMajorAPI(major:NSNumber) -> NSURL {
        let stringMajor:String = String(Int(major))
//        return NSURL(string: "http://192.168.42.1//Conference.json")!
        return NSURL(string: "https://gist.githubusercontent.com/frco9/95a6ef89c7d4d4e72c82/raw")!
    }
    
    class func buildingWithMajorAPI(major:NSNumber) -> NSURL {
        let stringMajor:String = String(Int(major))
//        return NSURL(string: "http://192.168.42.1/Building.json")!
        return NSURL(string: "https://gist.githubusercontent.com/frco9/3670e5e353aadea2c417/raw")!
    }
    
    
    class func beaconsAPI() -> NSURL {
//        return NSURL(string: "http://192.168.42.1/Beacons.json")!
        return NSURL(string: "https://gist.githubusercontent.com/frco9/2004da788773a4aa7e04/raw")!
    }
    
    
    private class func urlWithName(name: String, var args: [String: String]) -> NSURL {
        let
        baseURL      = "http://monserveur.com",
        queryString  = queryWithArgs(args),
        absolutePath = baseURL + name + "?" + queryString
        return NSURL(string: absolutePath)!
    }
    
    private class func queryWithArgs(args: [String: String]) -> String {
        let parts: [String] = reduce(args, [])
            {
                result, pair in
                let
                key   = pair.0,
                value = pair.1,
                part  = "\(key)=\(value)"
                return result + [part]
        }
        return (parts as NSArray).componentsJoinedByString("&")
    }
}
