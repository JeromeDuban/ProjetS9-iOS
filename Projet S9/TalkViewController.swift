//
//  TalkViewController.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 13/01/2015.
//  Copyright (c) 2015 Jérémie Foucault. All rights reserved.
//

import UIKit


class TalkViewController: UIViewController {
    
    var talk: Calendar?
    var isNotification: Bool = false;
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bodyLabel.frame = CGRectMake(0, 0, scrollView.frame.size.width, CGFloat.max);
        bodyLabel.numberOfLines = 0
        bodyLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        bodyLabel.text = talk?.body
        bodyLabel.sizeToFit()
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width,  self.bodyLabel.frame.size.height)
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 220.0, 0)
        
        speakerLabel.text = talk?.speaker
        roomLabel.text = "Amphi B"//talk?.room
        let _intervalStart:NSTimeInterval = 1421830800
        let dateStart: NSDate = NSDate(timeIntervalSince1970: _intervalStart)
        let formater: NSDateFormatter = NSDateFormatter()
        formater.locale = NSLocale.currentLocale()
        formater.dateFromString("HH:mm")
        let startTime: String = formater.stringFromDate(dateStart)
//
//        let _intervalEnd:NSTimeInterval = Double(talk!.end_ts)
//        let dateEnd: NSDate = NSDate(timeIntervalSince1970: _intervalEnd)
//        
//        let endTime: String = formater.stringFromDate(dateEnd)
//  
        timeLabel.text = "10:00 - 10:30"
        navigationItem.title = talk?.title
        var goToIcon: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Arrow"), style:UIBarButtonItemStyle.Plain, target:self, action:"goToMapAction")
        navigationItem.rightBarButtonItem  = goToIcon
        
        if self.isNotification {
            let dismissIcon: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "dismissNotification")
            navigationItem.rightBarButtonItem  = dismissIcon
        }
        

    }
    
    func dismissNotification() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func goToMapAction() {
        let viewController: UINavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("MapViewNavigation") as UINavigationController
        self.navigationController?.setViewControllers([viewController], animated: false)
        let mapViewController: MapViewController = viewController.viewControllers.first as MapViewController
        let myRoom: String = getDomId(self.talk!.room.toInt()!)
        
        mapViewController.fillRoomWithColor(myRoom, color: UIColor.redColor())
    }
    
    func getDomId(room_id: Int) ->String{
        var myTopology: Topology = Topology.sharedInstance
        
        var indexRooms: Int = 0;
        var indexFloors: Int = 0;
        var result: String = "";
        if(myTopology.floors?.count != nil){
            //Insert Rooms' name
            while(indexFloors != myTopology.floors?.count){
                
                while(indexRooms != myTopology.floors![indexFloors].rooms.count){
                    if(room_id == myTopology.floors![indexFloors].rooms[indexRooms].id){
                        result = myTopology.floors![indexFloors].rooms[indexRooms].dom_id;
                    }
                    
                    indexRooms += 1 ;
                }
                indexFloors += 1 ;
            }
            
        }
        return result
    }

    
}