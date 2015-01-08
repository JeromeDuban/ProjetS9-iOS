//
//  CalendarTableViewController .swift
//  Projet S9
//
//  Created by Guillaume SCHAHL on 07/01/2015.
//  Copyright (c) 2015 Jérémie Foucault. All rights reserved.
//

import Foundation


class CalendarTableViewControllerBis : BaseViewController, UITableViewDelegate,UITableViewDataSource   {


    @IBOutlet weak var tableView: UITableView!

    var items: [String] = ["We", "Heart", "Swift"]
    
    
    override func viewDidLoad() {
        super.unwindSegueIdentifier = "calendarUnwindSegueToMenu"
        super.viewDidLoad()
 
        navigationItem.title = "Calendar"
       // self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //var nib = UINib(nibName: "CustomCell", bundle: nil);

        
        //self.tableView.registerClass(CustomCell.self, forCellReuseIdentifier: "CellCalendarBis")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell

        var cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("CellCalendarBis", forIndexPath: indexPath) as CustomCell
        //cell.textLabel?.text = self.items[indexPath.row]


        println(self.items[indexPath.row])
        cell.setCell( self.items[indexPath.row], room: "Room n°"  , start_ts: "", end_ts: "", color: UIColor.greenColor())
        cell.setCellBis(self.items[indexPath.row])
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        
        return cell
    }
    
//    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        println("You selected cell #\(indexPath.row)!")
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("calendarDetail", sender: tableView)
    }
    
    @IBOutlet var titleSegue: NSLayoutConstraint!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "calendarDetail" {
            let calendarDetailViewController = segue.destinationViewController as UIViewController
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let destinationTitle = self.items[Ca]
            calendarDetailViewController.title = destinationTitle
            
            
            
            
        }
    }
    


}