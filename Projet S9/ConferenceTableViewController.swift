//
//  ConferenceTableViewController.swift
//  Projet S9
//
//  Created by Guillaume SCHAHL on 28/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import UIKit

struct ConferencesSearch {
    let category : String
    let name : String
}

class ConferenceTableViewController : UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var conferences = [ConferencesSearch]()
    
    var filteredConferences = [ConferencesSearch]()
    
    override func viewDidLoad() {
        // Data
        
        let myConference: Conference = Conference.sharedInstance
        let myTopology: Topology = Topology.sharedInstance
        var indexCount: Int = 0;
        var indexTracks: Int = 0;
        var indexSessions: Int = 0;
        var indexTalks: Int = 0;
        var indexFloors: Int = 0;
        var indexRooms: Int = 0;
        
        // Load the element in the tableview

        // Loop for tracks
        while(indexTracks != myConference.tracks?.count){

            // Insert track
            self.conferences.insert(ConferencesSearch(category:"Track", name:myConference.tracks![indexTracks].title.lowercaseString), atIndex: indexCount);
            indexCount += 1;
            
            
            // Loop for sessions
            while(indexSessions != myConference.tracks![indexTracks].sessions.count){
                // Insert session
                self.conferences.insert(ConferencesSearch(category:"Session", name: "session n°\(myConference.tracks![indexTracks].sessions[indexSessions].id) ") , atIndex: indexCount);
                indexCount += 1;
                
                
                // Loop for talks
                while(indexTalks != myConference.tracks![indexTracks].sessions[indexSessions].talks.count){
                    // Insert talks
                    self.conferences.insert(ConferencesSearch(category:"Talk", name:myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].title.lowercaseString) , atIndex: indexCount);
                    indexCount += 1;
                    indexTalks += 1;
                    
                }
                indexSessions += 1;
                
            }
            indexTracks += 1;
            
        }
        
        //Insert Rooms' name
        while(indexFloors != myTopology.floors?.count){
            
            while(indexRooms != myTopology.floors![indexFloors].rooms.count){
                // Insert track
                self.conferences.insert(ConferencesSearch(category:"Room", name:myTopology.floors![indexFloors].rooms[indexRooms].name.lowercaseString), atIndex: indexCount);
                
                indexCount += 1;
                indexRooms += 1;
            }
            
            indexFloors += 1;
        }
        
        
        
        // Reload the table
        self.tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredConferences.count
        } else {
            return self.conferences.count
        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool{
//        let secondViewController:HomeViewController = HomeViewController()
//        self.presentViewController(secondViewController, animated: true, completion: nil)
        return true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }


    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        
        var candy : ConferencesSearch
        // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            candy = filteredConferences[indexPath.row]
        } else {
            println(indexPath.section)
            candy = conferences[indexPath.row]
        }
        
        
        // Configure the cell
        cell.textLabel?.text = candy.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
        return cell
    }
    

    
    /*override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return newLabelWithTitle("Section \(section)")
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
    label.textAlignment = NSTextAlignment.Center
    label.backgroundColor = UIColor.grayColor()
    label.textColor = UIColor.whiteColor()
    label.text = "Room"
    return label
    }*/
    
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredConferences = self.conferences.filter({( conferences : ConferencesSearch) -> Bool in
            var categoryMatch = (scope == "All") || (conferences.category == scope)
            var stringMatch = conferences.name.rangeOfString(searchText.lowercaseString)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!,
        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
            let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
            self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
            return true
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.performSegueWithIdentifier("conferencesDetail", sender: tableView)
//    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if segue.identifier == "conferencesDetail" {
//            let detailViewController = segue.destinationViewController as UIViewController
//            
//            if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
//                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!              
//                let destinationTitle = self.filteredConferences[indexPath.row].name
//                detailViewController.title = destinationTitle
//            } else {
//                let indexPath = self.tableView.indexPathForSelectedRow()!
//                let destinationTitle = self.conferences[indexPath.row].name
//                detailViewController.title = destinationTitle
//                
//                
//                
//            }
//        }
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapAfterSearch") as UIViewController
        self.navigationController?.setViewControllers([viewController], animated: false)
        
        
        var alert = UIAlertController(title: "Alert", message: "Je vais afficher la salle de la recherche " + self.conferences[indexPath.row].name , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        

    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as CustomHeaderCell
        headerCell.backgroundColor = UIColor.grayColor()
        
        switch (section) {
        case 0:
            headerCell.headerLabel.text = "Track";
            headerCell.headerLabel.textColor = UIColor.whiteColor();
            //return sectionHeaderView
        case 1:
            headerCell.headerLabel.text = "Asia";
            //return sectionHeaderView
        case 2:
            headerCell.headerLabel.text = "South America";
            //return sectionHeaderView
        default:
            headerCell.headerLabel.text = "Other";
        }
        
        return headerCell
    }
   
    
    
}

class CustomHeaderCell: UITableViewCell {
    
    @IBOutlet var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
