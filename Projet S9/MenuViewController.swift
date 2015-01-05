//
//  MenuViewController.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 25/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    
    var menuItems = [MenuItem(title: "Home", identifier: "HomeViewNavigation", image: UIImage(named: "Home")!), MenuItem(title: "Map", identifier: "MapViewNavigation", image: UIImage(named: "Map")!),MenuItem(title: "Calendar", identifier: "CalendarViewNavigation", image: UIImage(named: "Calendar")!)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var bview: UIView = UIView()
        bview.backgroundColor = UIColor(red: 0x31/255.0, green: 0x31/255.0, blue: 0x31/255.0, alpha: 1.0)
        self.tableView.backgroundView = bview

        // This will remove extra separators from tableview
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // This set the top margin
        self.tableView.contentInset = UIEdgeInsetsMake(50.0, 0.0, 0.0, 0.0)
        
        self.slidingViewController().topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesture.Panning | ECSlidingViewControllerAnchoredGesture.Tapping
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMenuViewController(segue: UIStoryboardSegue) {
    }
    
    override func tableView(tableView:(UITableView!), numberOfRowsInSection section:Int) -> Int {
        return Int(menuItems.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as UITableViewCell
        
        let index = Int(indexPath.row)
        let menuItem = self.menuItems[index]
        
        let textLabel:UILabel = cell.viewWithTag(100) as UILabel
        textLabel.text =  menuItem.title
        textLabel.textColor = UIColor.whiteColor()
        
        let imageView:UIImageView = cell.viewWithTag(101) as UIImageView
        imageView.image = menuItem.image
        
        //  Change selection bg color
        var selectedCellView: UIView = UIView()
        selectedCellView.backgroundColor = UIColor(red: 0x69/255.0, green: 0x69/255.0, blue: 0x69/255.0, alpha: 1.0)
        cell.selectedBackgroundView = selectedCellView
        
        return cell

    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        
    }
    
    override func tableView(tableView: (UITableView!), didSelectRowAtIndexPath indexPath: (NSIndexPath!)) {
        let menuItem = self.menuItems[indexPath.row]
        
        self.slidingViewController().topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1)
        
        self.slidingViewController().topViewController = self.storyboard?.instantiateViewControllerWithIdentifier(menuItem.identifier) as UIViewController        
        
        self.slidingViewController().resetTopViewAnimated(true)

        
    }
}