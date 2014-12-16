//
//  MapViewController.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 14/12/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import UIKit

@objc(MapViewController) class MapViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var svgScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Map"
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}