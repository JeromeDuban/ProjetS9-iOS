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
    
    class func allConferences() -> NSURL {
        return NSURL(string: "http://jfoucault.rmorpheus.enseirb.fr/Conference_10.json")!
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
