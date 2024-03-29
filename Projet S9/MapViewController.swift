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
    var svgFile: SVGKImage = SVGKImage(named: "SS.svg")
    var svgMap: SVGKFastImageView = SVGKFastImageView(SVGKImage: SVGKImage(named: "SS.svg"))
    var isZoomed: Bool = false
    var isLocationCentered: Bool = false
    var layerSet: Bool = false
    var lastPosition: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var previousPosition: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var dotLayer: CAShapeLayer?
    var zoomScale: CGFloat = 1
    var domDefaultColor: UIColor = UIColor(red: 255/255, green: 222/255, blue: 0/255, alpha: 1)
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
        
        self.svgScrollView.addSubview(svgMap)
        self.svgScrollView.zoomToRect(svgMap.bounds, animated: false)
        
        self.singleTapGestureRecognizer.requireGestureRecognizerToFail(self.doubleTapGestureRecognizer)
        self.singleTapGestureRecognizer.delaysTouchesBegan = true
        self.singleTapGestureRecognizer.delaysTouchesBegan = true
        
        // Debug : Display beacons on map
//        let beaconLayer: CAShapeLayer = CAShapeLayer(layer: self.svgMap.layer)
//        self.makeCircleAtLocation(CGPoint(x: 451.2, y: 282.5), radius: 5, layer: beaconLayer, color: UIColor.redColor())
//        self.makeCircleAtLocation(CGPoint(x: 494.7, y: 282.5), radius: 5, layer: beaconLayer, color: UIColor.redColor())
//        self.makeCircleAtLocation(CGPoint(x: 472.95, y: 282.5), radius: 5, layer: beaconLayer, color: UIColor.redColor())
//        self.makeCircleAtLocation(CGPoint(x: 472.95, y: 297.5), radius: 5, layer: beaconLayer, color: UIColor.redColor())
//        self.svgMap.layer.addSublayer(beaconLayer)
//        self.svgMap.setNeedsDisplay()
        

        
    }
    
    @IBAction func singleTap(sender: UITapGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.Ended){
            let location:CGPoint = sender.locationInView(self.svgScrollView)
            let tree:CALayer = svgFile.CALayerTree
            if let hitLayer:CALayer = tree.hitTest(svgMap.convertPoint(location, fromView: self.svgScrollView)) {
                let svgElement:SVGElement? = self.SVGElementFromLayer(hitLayer)?
                if let identifier:String = svgElement?.getAttribute("id") {
                    if (!identifier.isEmpty && identifier != "contour") {
                        let alert:UIAlertView = UIAlertView(title: svgElement!.getAttribute("title"), message: "", delegate: nil, cancelButtonTitle: "Retour", otherButtonTitles: "Détails")
                        if hitLayer.isKindOfClass(CAShapeLayer) {
                            let shapeLayer:CAShapeLayer = hitLayer as CAShapeLayer
//                            shapeLayer.fillColor = UIColor.redColor().CGColor
                        }
                    }
                }
                self.svgMap.setNeedsDisplay()
            }
        }
    }

    @IBAction func doubleTap(sender: UITapGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.Ended)
        {
            if(isZoomed){
                self.svgScrollView.zoomToRect(svgMap.bounds, animated: true)
                isZoomed = false;
            }
            else{
                let location: CGPoint = sender.locationInView(svgMap)
                let rect: CGRect = CGRectMake(location.x - svgMap.bounds.size.width/8, location.y - svgMap.bounds.size.height/8, svgMap.bounds.size.width/4, svgMap.bounds.size.height/4)
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
        self.svgMap.disableAutoRedrawAtHighestResolution = false
        self.zoomScale = scale
        if self.dotLayer != nil {
            self.makeCircleAtLocation(self.lastPosition, radius: 20.0, layer: self.dotLayer!, color: UIColor.blueColor())
        }
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
        self.svgMap.disableAutoRedrawAtHighestResolution = true
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
        if beaconsVectors.count <= 0 {
            return
        }
        
        let barycenter = self.computeBarycenter(beaconsVectors)
        
        
        if !isLocationCentered {
            let rect: CGRect = CGRectMake(barycenter.x - 250, barycenter.y - 250, 500, 500)
            self.svgScrollView.zoomToRect(rect, animated: true)
            
            self.dotLayer = CAShapeLayer(layer: self.svgMap.layer)
            self.lastPosition = barycenter
            self.makeCircleAtLocation(barycenter, radius: 20.0, layer: self.dotLayer!, color: UIColor.blueColor())
            self.svgMap.layer.addSublayer(self.dotLayer)
            self.svgMap.setNeedsDisplay()
            
            self.isLocationCentered = true
        }
        self.dotLayer!.sublayers = nil
        self.makeCircleAtLocation(barycenter, radius: 20.0, layer: self.dotLayer!, color: UIColor.blueColor())

        self.lastPosition = barycenter
        self.svgMap.setNeedsDisplay()
    }

    
    
    private func findBeaconWithMajorAndMinor(major: NSNumber, minor: NSNumber) -> Beacon? {
        
        let beacons: Beacons = Beacons.sharedInstance
        if let beacon:Beacon = beacons.array!.filter({($0.major == major) && ($0.minor == minor)}).first? {
            return beacon
        }
        return nil
    }
    
    
    
    func makeCircleAtLocation(location: CGPoint, radius:CGFloat, layer:CAShapeLayer, color: UIColor) {
        let innerCirclePath: UIBezierPath = UIBezierPath(arcCenter: location, radius: radius/(3*self.zoomScale), startAngle: 0.0, endAngle: CGFloat(M_PI*2.0), clockwise: true)
        let centerCircle: CAShapeLayer = CAShapeLayer()
        centerCircle.path = innerCirclePath.CGPath
        centerCircle.fillColor = color.colorWithAlphaComponent(0.6).CGColor
        layer.addSublayer(centerCircle)
        
        
        let outerCirclePath: UIBezierPath = UIBezierPath(arcCenter: location, radius: radius/(1.5*self.zoomScale), startAngle: 0.0, endAngle: CGFloat(M_PI*2.0), clockwise: true)
        layer.path = outerCirclePath.CGPath
        layer.strokeColor = color.CGColor
        layer.fillColor = color.colorWithAlphaComponent(0.2).CGColor
        layer.opacity = 1
        layer.lineWidth = 0.1
    }
    
    
    
    
    func getVectorWeigth(beacon:CLBeacon) -> CGFloat {
        var distance:CGFloat = 1.0
        if beacon.accuracy > 0 {
            distance = CGFloat(beacon.accuracy)
        }
        switch beacon.proximity {
        case CLProximity.Far:
            return CGFloat(1)/distance
        case CLProximity.Near:
            return CGFloat(2)/distance
        case CLProximity.Immediate:
            return CGFloat(3)/distance
        case CLProximity.Unknown:
            return CGFloat(1)/distance
        }
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
        
        if self.lastPosition.x > 0 && self.lastPosition.y > 0 {
            // Check if this center is realistic
            if abs(xG - self.lastPosition.x) > 40 && abs(yG - self.lastPosition.y) > 40 {
                return self.lastPosition
            }
            
            // Avarage with the last barycenter
            xG = (xG + self.lastPosition.x) / 2
            yG = (yG + self.lastPosition.y) / 2
        }
        
        return CGPoint(x: xG, y: yG)
    }

    
    
    
    func fillRoomWithColor(dom_id:String, color:UIColor, reset: Bool = true) {
        if reset && !self.app.lastDomId.isEmpty {
            self.fillRoomWithColor(self.app.lastDomId, color: self.domDefaultColor, reset: false)
        }
        if let domElement:SVGElement = self.svgFile.DOMDocument!.getElementById(dom_id) as? SVGElement {
            if let elementLayer:CAShapeLayer = svgFile.layerWithIdentifier(domElement.identifier?) as? CAShapeLayer {
                self.app.lastDomId = dom_id
                elementLayer.fillColor = color.CGColor
            }
        }
        self.svgMap.setNeedsDisplay()
    }
    
    
    private func SVGElementFromLayer(layer:CALayer) -> SVGElement? {
        let list:NodeList = self.svgFile.DOMDocument!.getElementsByTagName("*")
        for domElement in list {
            let svgElement:SVGElement? = domElement as? SVGElement
            if (svgElement?.identifier != nil) {
                let nodeLayer:CALayer = svgFile.layerWithIdentifier(svgElement?.identifier?)
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