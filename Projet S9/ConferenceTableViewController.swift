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
        self.conferences = [ConferencesSearch(category:"Room", name:"amphi d"),
            ConferencesSearch(category:"Room", name:"amphi f"),
            ConferencesSearch(category:"Room", name:"td 9"),
            ConferencesSearch(category:"Track", name:"telecommunication"),
            ConferencesSearch(category:"Track", name:"informatique"),
            ConferencesSearch(category:"Session", name:"new tech"),
            ConferencesSearch(category:"Session", name:"new technologie"),
            ConferencesSearch(category:"Talk", name:"wifi 1"),
            ConferencesSearch(category:"Talk", name:"wifi 2")]
        
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
        cell.textLabel.text = candy.name
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
