//
//  MapViewController.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 14/12/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import UIKit

class MapViewController: BaseViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var doubleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var singleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var svgScrollView: UIScrollView!
    var svgFile: SVGKImage?
    var svgMap: SVGKImageView?
    var isZoomed: Bool = false
    
    override func viewDidLoad() {
        super.unwindSegueIdentifier = "mapUnwindSegueToMenu"
        super.viewDidLoad()
        
        navigationItem.title = "Map"
        
        self.svgScrollView.addGestureRecognizer(self.slidingViewController().panGesture)

        self.svgScrollView.sizeToFit()
        self.svgScrollView.minimumZoomScale = 0.25
        self.svgScrollView.maximumZoomScale = 2.5
        self.svgScrollView.showsHorizontalScrollIndicator = false
        self.svgScrollView.showsVerticalScrollIndicator = false
        self.svgScrollView.delegate = self
        
        self.displayFloor(1)
        self.svgMap = SVGKFastImageView(SVGKImage: svgFile)
        self.svgScrollView.addSubview(svgMap!)
        self.svgScrollView.zoomToRect(svgMap!.bounds, animated: false)
        
        self.singleTapGestureRecognizer.requireGestureRecognizerToFail(self.doubleTapGestureRecognizer)
        self.singleTapGestureRecognizer.delaysTouchesBegan = true
        self.singleTapGestureRecognizer.delaysTouchesBegan = true
        
    }
    
    @IBAction func singleTap(sender: UITapGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.Ended){
            let location:CGPoint = sender.locationInView(self.svgScrollView)
            let tree:CALayer = svgFile!.CALayerTree
            let hitLayer:CALayer = tree.hitTest(svgMap!.convertPoint(location, fromView: self.svgScrollView))
//            let identifier:String = SVGElement
            println("DoubleTap")
        }
    }

    @IBAction func doubleTap(sender: UITapGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.Ended)
        {
            if(isZoomed){
                self.svgScrollView.zoomToRect(svgMap!.bounds, animated: true)
                isZoomed = false;
            }
            else{
                let location: CGPoint = sender.locationInView(svgMap)
                let rect: CGRect = CGRectMake(location.x - svgMap!.bounds.size.width/8, location.y - svgMap!.bounds.size.height/8, svgMap!.bounds.size.width/4, svgMap!.bounds.size.height/4)
                self.svgScrollView.zoomToRect(rect, animated: true)
                isZoomed = true;
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false;
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
        self.svgScrollView.sizeToFit()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return self.svgMap
    }
    
}