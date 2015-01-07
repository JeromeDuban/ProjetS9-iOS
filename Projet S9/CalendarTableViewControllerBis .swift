//
//  CalendarTableViewController .swift
//  Projet S9
//
//  Created by Guillaume SCHAHL on 07/01/2015.
//  Copyright (c) 2015 Jérémie Foucault. All rights reserved.
//

import Foundation


class CalendarTableViewControllerBis : BaseViewController {


    override func viewDidLoad() {
        super.unwindSegueIdentifier = "calendarUnwindSegueToMenu"
        super.viewDidLoad()
 
        navigationItem.title = "Calendar"
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}