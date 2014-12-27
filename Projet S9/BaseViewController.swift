//
//  BaseViewController.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 21/12/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var unwindSegueIdentifier: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.slidingViewController().panGesture.delegate = self
        self.view.addGestureRecognizer(self.slidingViewController().panGesture)
        
        var menuIcon: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "MenuIcon"), style:UIBarButtonItemStyle.Plain, target:self, action:"menuButtonAction")
        
        navigationItem.leftBarButtonItem = menuIcon;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func menuButtonAction() {
        performSegueWithIdentifier(self.unwindSegueIdentifier, sender: self)
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer!) -> Bool {
        if (gestureRecognizer.locationInView(gestureRecognizer.view).x < 30.0) {
            return true
        }
        return false
    }


}
