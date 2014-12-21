//
//  MapViewController.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 14/12/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var svgScrollView: UIScrollView!
    var svgFile: SVGKImage = SVGKImage(named: "RDC.svg")
    var svgMap: SVGKImageView = SVGKFastImageView(SVGKImage: SVGKImage(named: "RDC.svg"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Map"
        
        self.slidingViewController().panGesture.delegate = self
        self.view.addGestureRecognizer(self.slidingViewController().panGesture)

        self.svgScrollView.sizeToFit()
        self.svgScrollView.minimumZoomScale = 0.25
        self.svgScrollView.maximumZoomScale = 2.5
        self.svgScrollView.showsHorizontalScrollIndicator = false
        self.svgScrollView.showsVerticalScrollIndicator = false
        self.svgScrollView.delegate = self
        
        self.displayFloor(1)
        svgMap = SVGKFastImageView(SVGKImage: svgFile)
        self.svgScrollView.addSubview(svgMap)
        self.svgScrollView.zoomToRect(svgMap.bounds, animated: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer!) -> Bool {
        if (gestureRecognizer.locationInView(gestureRecognizer.view).x < 30.0) {
            return true
        }
        return false
    }
    
    
    func displayFloor(index: Int) {
        switch (index) {
        case 0:
            self.svgFile = SVGKImage(named: "SS.svg")
            break
        case 1:
            self.svgFile = SVGKImage(named: "RDC.svg")
            break
        case 2:
            self.svgFile = SVGKImage(named: "RDC+1.svg")
            break
        case 3:
            self.svgFile = SVGKImage(named: "RDC+2.svg")
            break
        case 4:
            self.svgFile = SVGKImage(named: "RDC+3.svg")
            break
        default:
            self.svgFile = SVGKImage(named: "RDC.svg")
            break
        }
        
        self.svgMap.image = self.svgFile
        self.svgScrollView.sizeToFit()
        self.svgScrollView.zoomToRect(self.svgMap.bounds, animated: false)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return self.svgMap
    }
    
}