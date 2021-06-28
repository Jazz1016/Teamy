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
            fetchDetails()
            fetchEvents()
        }
    }
    
    
    
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
    
    func fetchDetails(){
        guard let team = team else {return}
        ContactController.shared.fetchContacts(teamId: team.teamId)
        AnnouncementController.shared.fetchAnnouncements(teamId: team.teamId)
        PlayerController.shared.fetchPlayers(teamId: team.teamId)
    }
}//End of class

extension TeamViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if AnnouncementController.shared.announcements.count > 0 {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if AnnouncementController.shared.announcements.count > 0 {
            if section == 1 {
                return nil
            } else if section == 2 {
                return "Announcements"
            } else {
                return "Events"
            }
        } else {
            if section == 1 {
                return nil
            } else {
                return "Events"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AnnouncementController.shared.announcements.count > 0 {
            if section == 1 {
                return ContactController.shared.contacts.count + 1
            } else if section == 2 {
                return AnnouncementController.shared.announcements.count
            } else if section == 3 {
                return EventController.shared.events.count
            } else {
                return 0
            }
        } else {
            if section == 1 {
                return 1
            } else {
                return EventController.shared.events.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if AnnouncementController.shared.announcements.count > 0 {
            if indexPath.row <= ContactController.shared.contacts.count + 1 {
                if indexPath.row <= ContactController.shared.contacts.count {
                    // JAMLEA: Contact Cells
                } else {
                    // JAMLEA: Roster Cell
                }
            } else if indexPath.row >= ContactController.shared.contacts.count + AnnouncementController.shared.announcements.count {
                // JAMLEA: Announcement Cells in here
            } else {
                
                // JAMLEA: Event cells in here
            }
        } else {
            if indexPath.row <= ContactController.shared.contacts.count + 1 {
                // JAMLEA: Manage Team Cell, Contact Cell(s), and roster cell in here
            } else {
                // JAMLEA: Event cells in here
            }
            
        }
        if EventController.shared.events.count > 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
            
            let event = EventController.shared.events[indexPath.row]
            cell.textLabel?.text = event.name
            cell.detailTextLabel?.text = event.date.dateValue().formatToString()
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let eventToDelete = EventController.shared.events[indexPath.row]
            guard let teamID = self.team?.teamId else {return}
            EventController.shared.deleteEvent(with: eventToDelete, teamID: teamID)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}//End of extension
