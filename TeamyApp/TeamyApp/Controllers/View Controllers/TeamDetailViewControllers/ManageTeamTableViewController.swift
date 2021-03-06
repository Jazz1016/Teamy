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
    
    override func viewDidAppear(_ animated: Bool) {
        guard let team = EventController.shared.team else {return}
        UserController.shared.fetchUsers(userIds: team.admins, access: "admin") { result in
            if !result {
                print("Error Fetching admins")
            }
        }
        UserController.shared.fetchUsers(userIds: team.members, access: "member") { result in
            if !result {
                print("Error Fetching members")
            }
        }
        UserController.shared.fetchUsers(userIds: team.blocked, access: "blocked") { result in
            if !result {
                print("Error Fetching blocked users")
            }
        }
    }
    
    //MARK: - Properties
    
    //MARK: - Methods
    func registerCells() {
        tableView.register(TeamNameTableViewCell.nib(), forCellReuseIdentifier: TeamNameTableViewCell.identifier)
        tableView.register(TeamBioTableViewCell.nib(), forCellReuseIdentifier: TeamBioTableViewCell.identifier)
        tableView.register(CoachsBioTableViewCell.nib(), forCellReuseIdentifier: CoachsBioTableViewCell.identifier)
        tableView.register(TeamContactsTableViewCell.nib(), forCellReuseIdentifier: TeamContactsTableViewCell.identifier)
        tableView.register(TeamAnnouncementsTableViewCell.nib(), forCellReuseIdentifier: TeamAnnouncementsTableViewCell.identifier)
        tableView.register(AdminMembersTableViewCell.nib(), forCellReuseIdentifier: AdminMembersTableViewCell.identifier)
        tableView.register(TeamMembersTableViewCell.nib(), forCellReuseIdentifier: TeamMembersTableViewCell.identifier)
    }
    
    func welcomeUser() {
        guard let user = UserController.shared.user else { return }
        welcomeLabel.text = "Welcome, \(user.firstName) \(user.lastName)"
    }
    
    func updatedColor() {
        self.tableView.reloadData()
        
        let colorIndexPath = IndexPath(row: 2, section: 0)
        guard let colorCell = self.tableView.dequeueReusableCell(withIdentifier: "editTeamColorCell", for: colorIndexPath)
                as? EditTeamColorTableViewCell else { return }
        colorCell.awakeFromNib()
        
        let contactsIndexPath = IndexPath(row: 0, section: 1)
        guard let contactsCell = self.tableView.dequeueReusableCell(withIdentifier: TeamContactsTableViewCell.identifier, for: contactsIndexPath)
                as? TeamContactsTableViewCell else { return }
        contactsCell.awakeFromNib()
        
        let announcementsIndexPath = IndexPath(row: 1, section: 1)
        guard let announcementsCell = self.tableView.dequeueReusableCell(withIdentifier: TeamAnnouncementsTableViewCell.identifier, for: announcementsIndexPath)
                as? TeamAnnouncementsTableViewCell else { return }
        announcementsCell.awakeFromNib()
        
        let adminMembersIndexPath = IndexPath(row: 0, section: 2)
        guard let adminMembersCell = self.tableView.dequeueReusableCell(withIdentifier: AdminMembersTableViewCell.identifier, for: adminMembersIndexPath)
                as? AdminMembersTableViewCell else { return }
        adminMembersCell.awakeFromNib()
        
        let teamMembersIndexPath = IndexPath(row: 1, section: 2)
        guard let teamMembersCell = self.tableView.dequeueReusableCell(withIdentifier: TeamMembersTableViewCell.identifier, for: teamMembersIndexPath)
                as? TeamMembersTableViewCell else { return }
        teamMembersCell.awakeFromNib()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 3
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
            cell = tableView.dequeueReusableCell(withIdentifier: "editTeamColorCell", for: indexPath) as? EditTeamColorTableViewCell
        } else if indexPath.section == 1 && indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: TeamContactsTableViewCell.identifier, for: indexPath)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: TeamAnnouncementsTableViewCell.identifier, for: indexPath)
        } else if indexPath.section == 2 && indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: AdminMembersTableViewCell.identifier, for: indexPath)
        } else if indexPath.section == 2 && indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: TeamMembersTableViewCell.identifier, for: indexPath)
        }
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            return true
        } else if indexPath.section == 0 && indexPath.row == 1 {
            return true
        } else {
            return false
        }
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            let editAction = UITableViewRowAction(style: .default, title: "Edit") { action, indexPath in
                if let cell = tableView.cellForRow(at: indexPath) as? TeamNameTableViewCell {
                    cell.updateForEdit()
                }
            }
            editAction.backgroundColor = .systemBlue
            return [editAction]
        
        } else if indexPath.section == 0 && indexPath.row == 1 {
            
            let editAction = UITableViewRowAction(style: .default, title: "Edit") { action, indexPath in
                if let cell = tableView.cellForRow(at: indexPath) as? TeamBioTableViewCell {
                    cell.updateForEdit()
                }
            }
            
            editAction.backgroundColor = .systemBlue
            return [editAction]
        } else {
            return []
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if indexPath.section == 0 && indexPath.row == 2 {
            
            let colorPickerVC = UIColorPickerViewController()
            colorPickerVC.delegate = self
        
            present(colorPickerVC, animated: true, completion: nil)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let VC = storyboard.instantiateViewController(identifier: "editContactsVC")
            VC.modalPresentationStyle = .automatic
            self.present(VC, animated: true, completion: nil)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            let VC = storyboard.instantiateViewController(identifier: "editAnnouncementsVC")
            
            VC.modalPresentationStyle = .automatic
            
            self.present(VC, animated: true, completion: nil)
        } else if indexPath.section == 2 && indexPath.row == 0 {
            let VC = storyboard.instantiateViewController(identifier: "AccessVC")
            
            VC.modalPresentationStyle = .automatic
            self.present(VC, animated: true, completion: nil)
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
        let updatedTeam = Team(name: currentTeam.name, teamColor: color.toHexString(), teamSport: currentTeam.teamSport, teamRecord: currentTeam.teamRecord, leagueName: currentTeam.leagueName, teamBio: currentTeam.teamBio, admins: currentTeam.admins, members: currentTeam.members, blocked: currentTeam.blocked, teamId: currentTeam.teamId, teamCode: currentTeam.teamCode, teamImage: currentTeam.teamImage)
        
        TeamController.shared.editTeam(oldTeam: currentTeam, team: updatedTeam)
        tableView.reloadData()
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        updatedColor()
    }
}
