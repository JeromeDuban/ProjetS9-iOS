//
//  MapViewController.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 14/12/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import UIKit
import CoreLocation

class MapViewController: BaseViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var doubleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var singleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var svgScrollView: UIScrollView!
    var svgFile: SVGKImage?
    var svgMap: SVGKFastImageView?
    var isZoomed: Bool = false
    var isLocationCentered: Bool = false
    var layerSet: Bool = false
    var lastPosition: CGPoint = CGPoint(x: 0.0, y: 0.0)
    let app:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
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
            if let hitLayer:CALayer = tree.hitTest(svgMap!.convertPoint(location, fromView: self.svgScrollView)) {
                let svgElement:SVGElement? = self.SVGElementFromLayer(hitLayer)?
                if let identifier:String = svgElement?.getAttribute("id") {
                    if (!identifier.isEmpty && identifier != "contour") {
                        let alert:UIAlertView = UIAlertView(title: svgElement!.getAttribute("title"), message: "", delegate: nil, cancelButtonTitle: "Retour", otherButtonTitles: "Détails")
                        if hitLayer.isKindOfClass(CAShapeLayer) {
                            let shapeLayer:CAShapeLayer = hitLayer as CAShapeLayer
                            shapeLayer.fillColor = UIColor.redColor().CGColor
                        }
                    }
                }
                self.svgMap!.setNeedsDisplay()
            }
            
            
            
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
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleBeaconsUpdate", name: "beaconUpdate", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        self.svgMap!.disableAutoRedrawAtHighestResolution = false
       
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
        self.svgMap!.disableAutoRedrawAtHighestResolution = true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false;
    }
    
    func handleBeaconsUpdate() {
        var beaconsVectors: [(coordinate:CGPoint, weigth:CGFloat)] = []
        for nearestBeacon:CLBeacon in app.lastBeacons! {
            if let beaconFound: Beacon = self.findBeaconWithMajorAndMinor(nearestBeacon.major, minor: nearestBeacon.minor) {
                let vector:(coordinate:CGPoint, weigth:CGFloat) = (coordinate: beaconFound.coordinates, weigth: self.getVectorWeigth(nearestBeacon))
                beaconsVectors.append(vector)
            }
        }
        let barycenter = self.computeBarycenter(beaconsVectors)
        
        let shapeLayer:CAShapeLayer = CAShapeLayer(layer: self.svgMap!.layer)
        
        if !isLocationCentered {
            let rect: CGRect = CGRectMake(barycenter.x - 150, barycenter.y - 150, 300, 300)
            self.svgScrollView.zoomToRect(rect, animated: true)
            
            self.lastPosition = barycenter
            self.makeCircleAtLocation(barycenter, radius: 10.0, layer: shapeLayer)
            self.svgMap!.layer.addSublayer(shapeLayer)
            self.svgMap!.setNeedsDisplay()
            
            self.isLocationCentered = true
        }
        let newPosition: CGPoint = CGPoint(x: barycenter.x - self.lastPosition.x, y: barycenter.y - self.lastPosition.y)
        shapeLayer.position = newPosition
//        self.moveLayer(shapeLayer, point: barycenter)
        self.lastPosition = barycenter
        self.svgMap!.setNeedsDisplay()
    }

    private func findBeaconWithMajorAndMinor(major: NSNumber, minor: NSNumber) -> Beacon? {
        let beacons: Beacons = Beacons.sharedInstance
        if let beacon:Beacon = beacons.array!.filter({($0.major == major) && ($0.minor == minor)}).first? {
            return beacon
        }
        return nil
    }
    
    func makeCircleAtLocation(location: CGPoint, radius:CGFloat, layer:CAShapeLayer) {
        let outerCirclePath: UIBezierPath = UIBezierPath(arcCenter: location, radius: radius, startAngle: 0.0, endAngle: CGFloat(M_PI*2.0), clockwise: true)
        let innerCirclePath: UIBezierPath = UIBezierPath(arcCenter: location, radius: 1, startAngle: 0.0, endAngle: CGFloat(M_PI*2.0), clockwise: true)
        outerCirclePath.appendPath(innerCirclePath)
        outerCirclePath.usesEvenOddFillRule = true
        
        layer.path = outerCirclePath.CGPath
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillRule = kCAFillRuleEvenOdd
        layer.fillColor = UIColor.grayColor().CGColor
        layer.opacity = 0.5
        layer.lineWidth = 1.0
    }
    
    func getVectorWeigth(beacon:CLBeacon) -> CGFloat {
        switch beacon.proximity {
        case CLProximity.Far:
            return CGFloat(1)
        case CLProximity.Near:
            return CGFloat(2)
        case CLProximity.Immediate:
            return CGFloat(3)
        case CLProximity.Unknown:
            return CGFloat(1)
        }
    }
    
    func moveLayer(layer:CAShapeLayer, point:CGPoint) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "position")
        let newPosition: CGPoint = CGPoint(x: point.x - self.lastPosition.x, y: point.y - self.lastPosition.y)
        animation.fromValue = layer.valueForKey("position")
        animation.toValue = NSValue(CGPoint: newPosition)
        animation.duration = 2
        layer.position = newPosition
        layer.addAnimation(animation, forKey: "position")
    }
    
    func computeBarycenter(vectors: [(coordinate:CGPoint, weigth:CGFloat)]) -> CGPoint {
        var xG:CGFloat = 0.0
        var xGWeigth: CGFloat = 0.0
        var yG:CGFloat = 0.0
        var yGWeigth:CGFloat = 0.0
        for vector:(coordinate:CGPoint, weigth:CGFloat) in vectors {
            xG += vector.coordinate.x * CGFloat(vector.weigth)
            yG += vector.coordinate.y * CGFloat(vector.weigth)
            xGWeigth += CGFloat(vector.weigth)
            yGWeigth += CGFloat(vector.weigth)
        }
        xG /= xGWeigth
        yG /= yGWeigth
        return CGPoint(x: xG, y: yG)
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
    
    func SVGElementFromLayer(layer:CALayer) -> SVGElement? {
        let list:NodeList = self.svgFile!.DOMDocument!.getElementsByTagName("*")
        for domElement in list {
            let svgElement:SVGElement? = domElement as? SVGElement
            if (svgElement?.identifier != nil) {
                let nodeLayer:CALayer = svgFile!.layerWithIdentifier(svgElement?.identifier?)
                if nodeLayer == layer {
                    return svgElement
                }
            }
        }
        return nil
    }

    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return self.svgMap
    }
    
}

extension NodeList: SequenceType {
    public func generate() -> NSFastGenerator {
        return NSFastGenerator(self)
    }
}