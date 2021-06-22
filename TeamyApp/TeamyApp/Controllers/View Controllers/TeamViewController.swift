//
//  TeamViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/21/21.
//

import UIKit

class TeamViewController: UIViewController {
    @IBOutlet weak var eventsTableViewController: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: - Properties
    var team: Team?
    
    // MARK: - Methods
 

}//End of class

extension TeamViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // JAMLEA: Placeholder
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // JAMLEA: Placeholder
        return UITableViewCell()
    }
    
    
}//End of extension
