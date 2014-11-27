//
//  ExternalData.swift
//  Projet S9
//
//  Created by Guillaume SCHAHL on 27/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import Foundation


class ExternalData{
    
    
    func getData(){
        
        let urlPath: String = "https://dl.dropboxusercontent.com/u/95538366/projetS9/conference.json"
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer <NSURLResponse?
        >=nil
        
        var error: AutoreleasingUnsafeMutablePointer <NSErrorPointer?>=nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
        var err: NSError
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        var myData = NSString(data: dataVal, encoding: NSUTF8StringEncoding)
        /*let someVar = jsonResult["Conference"]
        let varr = jsonResult["address"]*/
        
        let json = JSON(data: dataVal)
        let varr = json["Conference"][0]["address"]
        println("Synchronous \(varr)")
        
    }
    
}