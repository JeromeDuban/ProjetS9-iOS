//
//  MenuViewController.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 25/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.slidingViewController().topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesture.Panning | ECSlidingViewControllerAnchoredGesture.Tapping
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMenuViewController(segue: UIStoryboardSegue) {
        println("Open Menu");
    }
    
    
}