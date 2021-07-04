//
//  ManageTeamTableViewController.swift
//  TeamyApp
//
//  Created by anthony byrd on 6/24/21.
//

import UIKit

class ManageTeamTableViewController: UITableViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        welcomeUser()
    }
    
    //MARK: - Properties
    
    //MARK: - Methods
    func registerCells() {
        tableView.register(TeamNameTableViewCell.nib(), forCellReuseIdentifier: TeamNameTableViewCell.identifier)
        tableView.register(TeamBioTableViewCell.nib(), forCellReuseIdentifier: TeamBioTableViewCell.identifier)
        tableView.register(CoachsBioTableViewCell.nib(), forCellReuseIdentifier: CoachsBioTableViewCell.identifier)
        tableView.register(TeamEventsTableViewCell.nib(), forCellReuseIdentifier: TeamEventsTableViewCell.identifier)
        tableView.register(TeamAnnouncementsTableViewCell.nib(), forCellReuseIdentifier: TeamAnnouncementsTableViewCell.identifier)
        tableView.register(AdminMembersTableViewCell.nib(), forCellReuseIdentifier: AdminMembersTableViewCell.identifier)
        tableView.register(TeamMembersTableViewCell.nib(), forCellReuseIdentifier: TeamMembersTableViewCell.identifier)
    }
    
    func welcomeUser() {
        guard let user = UserController.shared.user else { return }
        welcomeLabel.text = "Welcome, \(user.firstName) \(user.lastName)"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 4
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?

        if indexPath.section == 0 && indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: TeamNameTableViewCell.identifier, for: indexPath)
        } else if indexPath.section == 0 && indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: TeamBioTableViewCell.identifier, for: indexPath)
        } else if indexPath.section == 0 && indexPath.row == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: CoachsBioTableViewCell.identifier, for: indexPath)
        } else if indexPath.section == 0 && indexPath.row == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "editTeamColorCell", for: indexPath) as? EditTeamColorTableViewCell
        } else if indexPath.section == 1 && indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: TeamEventsTableViewCell.identifier, for: indexPath)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: TeamAnnouncementsTableViewCell.identifier, for: indexPath)
        } else if indexPath.section == 2 && indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: AdminMembersTableViewCell.identifier, for: indexPath)
        } else if indexPath.section == 2 && indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: TeamMembersTableViewCell.identifier, for: indexPath)
        }
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 3 {
            
            let colorPickerVC = UIColorPickerViewController()
            colorPickerVC.delegate = self
        
            present(colorPickerVC, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "TEAM DETAILS"
        } else if section == 1 {
            return "INFORM THE TEAM"
        } else if section == 2 {
            return "MANAGE TEAM MEMBERS"
        } else {
            return nil
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

//MARK: - Extensions
extension ManageTeamTableViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        //AnthonyByrd - Discuss with team which method to use
        guard let currentTeam = EventController.shared.team else { return }
        let color = viewController.selectedColor
        
        currentTeam.teamColor = color.toHexString()
        let updatedTeam = Team(name: currentTeam.name, teamColor: color.toHexString(), teamSport: currentTeam.teamSport, admins: currentTeam.admins, members: currentTeam.members, blocked: currentTeam.blocked, teamDesc: currentTeam.teamDesc, teamId: currentTeam.teamId, teamCode: currentTeam.teamCode, teamImage: currentTeam.teamImage)
        
        TeamController.shared.editTeam(oldTeam: currentTeam, team: updatedTeam)
        tableView.reloadData()
    }
}
