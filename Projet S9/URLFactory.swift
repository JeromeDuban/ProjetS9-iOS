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
        return NSURL(string: "https://gist.githubusercontent.com/frco9/95a6ef89c7d4d4e72c82/raw/cc1684e795566c08103ce87b7841715a45aa5679/Conference_"+stringMajor+".json")!
    }
    
    class func buildingWithMajorAPI(major:NSNumber) -> NSURL {
        let stringMajor:String = String(Int(major))
        return NSURL(string: "https://gist.githubusercontent.com/frco9/3670e5e353aadea2c417/raw/7ae27e0ac33388cfbc35107e802feeaf51535c18/Topology_"+stringMajor+".json")!
    }
    
    
    class func beaconsAPI() -> NSURL {
        return NSURL(string: "https://gist.githubusercontent.com/frco9/2004da788773a4aa7e04/raw/d0617a83eb45b65e08f5f48bf5e4e3696eaec0f1/Beacons.json")!
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
