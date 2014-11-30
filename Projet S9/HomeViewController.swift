//
//  HomeViewController.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 25/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIGestureRecognizerDelegate, UIBarPositioningDelegate {

    var conferences: [Conference] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.slidingViewController().panGesture.delegate = self
        
        self.view.addGestureRecognizer(self.slidingViewController().panGesture)

        self.getConferencesFromAPI()
    }
    

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer!) -> Bool {
        if (gestureRecognizer.locationInView(gestureRecognizer.view).x < 30.0) {
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func getConferencesFromAPI() {
        let url = URLFactory.allConferences()
        JSONService
            .GET(url)
            .success{json in {self.makeConferences(json)} ~> {
                self.logConferences($0)
                self.conferences = $0
            }}
            .failure(onFailure, queue: NSOperationQueue.mainQueue())
    }
    
    private func makeConferences(json: AnyObject) -> [Conference] {
        let jsonParsed: JSON = JSON(json)
        if let conferences = ModelBuilder.buildConferencesFromJSON(jsonParsed) as? [Conference] {
            if let unique = NSSet(array: conferences).allObjects as? [Conference] {
                return unique.sorted { $0.title < $1.title }
            }
        }
        return []
    }
    
    private func logConferences(conferences: [Conference]) {
        NSLog("Conference id: \(conferences[0].id)\n Title: \(conferences[0].title)")
    }
    
    private func onFailure(statusCode: Int, error: NSError?)
    {
        println("HTTP status code \(statusCode)")
        
        let
        title = "Error",
        msg   = error?.localizedDescription ?? "An error occurred.",
        alert = UIAlertController(
            title: title,
            message: msg,
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: { _ in
                self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    func findConferenceWithMajor(major: NSNumber) -> Conference {
        return self.conferences.filter({$0.major == major}).first!
    }



}

