//
//  TeamViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/21/21.
//

import UIKit
import FirebaseAuth

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
                guard let user = Auth.auth().currentUser else {return}
                if EventController.shared.team!.admins.contains(user.uid) {
                    EventController.shared.isAdmin = true
                    
                }
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
        //Ethan - I changed the below code from = to >= so I could view the Event cells
        if AnnouncementController.shared.announcements.count >= 0 {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            if section == 0 {
                return nil
            } else if section == 1 {
                return "Announcements"
            } else {
                return "Events"
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if EventController.shared.isAdmin {
            if AnnouncementController.shared.announcements.count > 0 {
                if section == 0 {
                    return ContactController.shared.contacts.count + 2
                } else if section == 1 {
                    return AnnouncementController.shared.announcements.count
                } else if section == 2 {
                    return EventController.shared.events.count
                } else {
                    return 0
                }
            } else {
                if section == 0 {
                    return ContactController.shared.contacts.count + 2
                } else {
                    return EventController.shared.events.count
                }
            }
        } else {
            if AnnouncementController.shared.announcements.count > 0 {
                if section == 0 {
                    return ContactController.shared.contacts.count + 1
                } else if section == 1 {
                    return AnnouncementController.shared.announcements.count
                } else if section == 2 {
                    return EventController.shared.events.count
                } else {
                    return 0
                }
            } else {
                if section == 0 {
                    return ContactController.shared.contacts.count + 1
                } else {
                    return EventController.shared.events.count
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if EventController.shared.isAdmin {
                if indexPath.row == 0 && indexPath.section == 0 {
                    /// Manage Team Button Cell
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "manageCell", for: indexPath) as?  ManageTeamTableViewCell else {return UITableViewCell()}
                    return cell
                } else if indexPath.row <= 1 && indexPath.section == 0 {
                    /// Roster Cell
                    let cell = tableView.dequeueReusableCell(withIdentifier: "rosterCell", for: indexPath) as? RosterCellTableViewCell
                    return cell ?? UITableViewCell()
                } else if indexPath.row <= ContactController.shared.contacts.count + 1 && indexPath.section == 0 {
                    /// Contact Cell(s)
                    let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactCellTableViewCell
                    let contact = ContactController.shared.contacts[indexPath.row - 2]
                    cell?.contact = contact
                    return cell ?? UITableViewCell()
                } else if indexPath.row <= AnnouncementController.shared.announcements.count && indexPath.section == 1 {
                    /// Announcement Cell(s)
                    let cell = tableView.dequeueReusableCell(withIdentifier: "announcementCell", for: indexPath) as? AnnounceTableViewCell
                    return cell ?? UITableViewCell()
                } else if indexPath.row == 0 && indexPath.section == 2 {
                    
                    
                } else if indexPath.row <= EventController.shared.events.count && indexPath.section == 2 {
                    /// Event Cell(s)
                      guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else {return UITableViewCell()}
                    
                    let event = EventController.shared.events[indexPath.row]
                    cell.eventNameLabel.text = event.name
                    cell.eventLocationLabel.text = event.locationName
                    cell.eventDate.text = event.date.dateValue().formatToString()
            
                    return cell
                } else {
                    return UITableViewCell()
            }
        } else {
            // JAMLEA: put non admin setup here
            if indexPath.row == 0 && indexPath.section == 0 {
                /// Roster Cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "rosterCell", for: indexPath) as? RosterCellTableViewCell
                return cell ?? UITableViewCell()
            } else if indexPath.row <= ContactController.shared.contacts.count && indexPath.section == 0 {
                /// Contact Cell(s)
                let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactCellTableViewCell
                let contact = ContactController.shared.contacts[indexPath.row - 1]
                cell?.contact = contact
                return cell ?? UITableViewCell()
            } else if indexPath.row <= AnnouncementController.shared.announcements.count && indexPath.section == 1 {
                /// Announcement Cell(s)
                let cell = tableView.dequeueReusableCell(withIdentifier: "announcementCell", for: indexPath) as? AnnounceTableViewCell
                return cell ?? UITableViewCell()
            } else if indexPath.row <= EventController.shared.events.count && indexPath.section == 2 {
                /// Event Cell(s)   
              guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else {return UITableViewCell()}
            
                let event = EventController.shared.events[indexPath.row]
                cell.eventNameLabel.text = event.name
                cell.eventLocationLabel.text = event.locationName
                cell.eventDate.text = event.date.dateValue().formatToString()
            
                return cell
            } else {
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let eventToDelete = EventController.shared.events[indexPath.row]
//            guard let teamID = self.team?.teamId else {return}
//            EventController.shared.deleteEvent(with: eventToDelete, teamID: teamID)
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventDetailVC" {
            guard let indexPath = eventsTableView.indexPathForSelectedRow else {return}
            guard let destinationVC = segue.destination as? EventDetailViewController else {return}
            let eventToSend = EventController.shared.events[indexPath.row]
            destinationVC.event = eventToSend
        }
    }
}//End of extension

