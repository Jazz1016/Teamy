//
//  TeamViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/21/21.
//

import UIKit

class TeamViewController: UIViewController {
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
    }
    
    
    // MARK: - Properties
    var team: Team? {
        didSet {
            DispatchQueue.main.async {
                EventController.shared.team = self.team
            }
            fetchEvents()
        }
    }
    
    var announcements: Array<String> = []
    
    // MARK: - Methods
    func fetchEvents() {
        guard let team = team else {return}
        EventController.shared.fetchEvents(teamID: team.teamId) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.eventsTableView.reloadData()
                    print("Successfully fetched events")
                }
            }
        }
    }

}//End of class

extension TeamViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // JAMLEA: Placeholder
        if section == 1 {
            return 3
        } else if section == 2 {
            return announcements.count
        } else if section == 3 {
            return EventController.shared.events.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        let event = EventController.shared.events[indexPath.row]
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = event.date.dateValue().formatToString()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let eventToDelete = EventController.shared.events[indexPath.row]
            EventController.shared.deleteEvent(with: eventToDelete)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}//End of extension
