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
    var conferencesInTrack = [ConferencesSearch]()
    var conferencesInSection = [ConferencesSearch]()
    var conferencesInTalk = [ConferencesSearch]()
    var conferencesInRoom = [ConferencesSearch]()
    
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
        
        
        var indexCountSection: Int = 0;
        var indexCountTalk: Int = 0;
        var indexCountRoom: Int = 0;
        var indexCountTrack: Int = 0;
        // Load the element in the tableview

        
        if(myConference.tracks?.count != nil){
        // Loop for tracks
        while(indexTracks  != myConference.tracks?.count){

            // Insert track
            self.conferences.insert(ConferencesSearch(category:"Track", name:myConference.tracks![indexTracks].title.lowercaseString), atIndex: indexCount);
            self.conferencesInTrack.insert(ConferencesSearch(category:"Track", name:myConference.tracks![indexTracks].title.lowercaseString), atIndex: indexCountTrack);
            indexCount += 1;
            indexCountTrack += 1;
            
            
            // Loop for sessions
            while(indexSessions != myConference.tracks![indexTracks].sessions.count){
                // Insert session
                self.conferences.insert(ConferencesSearch(category:"Session", name: "session n°\(myConference.tracks![indexTracks].sessions[indexSessions].id) ") , atIndex: indexCount);
                self.conferencesInSection.insert(ConferencesSearch(category:"Session", name: "session n°\(myConference.tracks![indexTracks].sessions[indexSessions].id) ") , atIndex: indexCountSection);
                
                indexCountSection += 1;
                indexCount += 1;
                
                
                // Loop for talks
                while(indexTalks != myConference.tracks![indexTracks].sessions[indexSessions].talks.count){
                    // Insert talks
                    self.conferences.insert(ConferencesSearch(category:"Talk", name:myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].title.lowercaseString) , atIndex: indexCount);
                    self.conferencesInTalk.insert(ConferencesSearch(category:"Talk", name:myConference.tracks![indexTracks].sessions[indexSessions].talks[indexTalks].title.lowercaseString) , atIndex: indexCountTalk);
                    
                    indexCountTalk += 1;
                    indexCount += 1;
                    indexTalks += 1;
                    
                }
                indexSessions += 1;
                indexTalks = 0;
                
            }
            
            indexTracks += 1;
            indexSessions = 0;
            
        }
        }
        
        if(myTopology.floors?.count != nil){
        //Insert Rooms' name
        while(indexFloors != myTopology.floors?.count){
            
            while(indexRooms != myTopology.floors![indexFloors].rooms.count){
                // Insert track
                self.conferences.insert(ConferencesSearch(category:"Room", name:myTopology.floors![indexFloors].rooms[indexRooms].name.lowercaseString), atIndex: indexCount);
                self.conferencesInRoom.insert(ConferencesSearch(category:"Room", name:myTopology.floors![indexFloors].rooms[indexRooms].name.lowercaseString), atIndex: indexCountRoom);
                
                indexCountRoom += 1;
                indexCount += 1;
                indexRooms += 1;
            }
            
            indexFloors += 1;
        }
        }
        
        
        
        // Reload the table
        self.tableView.reloadData()
    }
    
    
    

    // Define the number of row
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredConferences.count
        } else {
            switch (section) {
            case 0:
                return conferencesInTrack.count;
            case 1:
                return conferencesInSection.count;
            case 2:
                return conferencesInTalk.count;
            case 3:
                return conferencesInRoom.count;
            default:
                return 1
            }
            //return self.conferences.count
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return 1;
        } else {
            return 4;
        }        
    
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool{
//        let secondViewController:HomeViewController = HomeViewController()
//        self.presentViewController(secondViewController, animated: true, completion: nil)
        return true
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        
        var conferencesRow : ConferencesSearch
        // Check to see whether the normal table or search results table is being displayed and set the Conferencesj object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {

            conferencesRow = filteredConferences[indexPath.row]

        } else {

            switch (indexPath.section) {
            case 0:
                conferencesRow = conferencesInTrack[indexPath.row]
            case 1:
                conferencesRow = conferencesInSection[indexPath.row]
            case 2:
                conferencesRow = conferencesInTalk[indexPath.row]
            case 3:
                conferencesRow = conferencesInRoom[indexPath.row]
            default:
                conferencesRow = conferences[indexPath.row]
            }
            
            //conferencesRow = conferences[indexPath.row]
        }
        
        
        // Configure the cell
        cell.textLabel?.text = conferencesRow.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
        return cell
    }

    
    
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

        //let viewController: UINavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("MapViewNavigation") as UINavigationController
        //self.navigationController?.setViewControllers([viewController], animated: false)
        //let mapViewController: MapViewController = viewController.viewControllers.first as MapViewController
        
        //mapViewController.fillRoomWithColor("i003", color: UIColor.redColor())

        switch(indexPath.section){
        case 0:
            println(self.conferencesInTrack[indexPath.row].name)
        case 1:
            println(self.conferencesInSection[indexPath.row].name)
        case 2:
            println(self.conferencesInTalk[indexPath.row].name)
        case 3:
            println(self.conferencesInRoom[indexPath.row].name)
        default:
            println("Error")
        }

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
            headerCell.headerLabel.text = "Session";
            headerCell.headerLabel.textColor = UIColor.whiteColor();
            //return sectionHeaderView
        case 2:
            headerCell.headerLabel.text = "Talk";
            headerCell.headerLabel.textColor = UIColor.whiteColor();
            //return sectionHeaderView
        case 3:
            headerCell.headerLabel.text = "Room";
            headerCell.headerLabel.textColor = UIColor.whiteColor();
            //return sectionHeaderView
        default:
            headerCell.headerLabel.text = "Error";
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
