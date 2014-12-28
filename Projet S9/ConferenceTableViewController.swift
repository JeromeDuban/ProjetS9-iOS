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
        // Sample Data for candyArray
        
        let myConference: Conference = Conference.sharedInstance
        var indexCount: Int = 0;
        var indexTracks: Int = 0;
        var indexSessions: Int = 0;
        var indexTalks: Int = 0;
        
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
    

    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        
        var candy : ConferencesSearch
        // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            candy = filteredConferences[indexPath.row]
        } else {
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
    

    
    
    
    
}
