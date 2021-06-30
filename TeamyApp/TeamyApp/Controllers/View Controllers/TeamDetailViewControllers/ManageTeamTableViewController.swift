//
//  ManageTeamTableViewController.swift
//  TeamyApp
//
//  Created by anthony byrd on 6/24/21.
//

import UIKit

class ManageTeamTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
    }
    
    //MARK: - Properties
    var user: User?
    var team: Team?
    
    //MARK: - Methods
    func registerCells() {
        tableView.register(TeamNameTableViewCell.nib(), forCellReuseIdentifier: TeamNameTableViewCell.identifier)
        tableView.register(TeamBioTableViewCell.nib(), forCellReuseIdentifier: TeamBioTableViewCell.identifier)
        tableView.register(CoachsBioTableViewCell.nib(), forCellReuseIdentifier: CoachsBioTableViewCell.identifier)
        tableView.register(TeamColorTableViewCell.nib(), forCellReuseIdentifier: TeamColorTableViewCell.identifier)
        tableView.register(TeamEventsTableViewCell.nib(), forCellReuseIdentifier: TeamEventsTableViewCell.identifier)
        tableView.register(TeamAnnouncementsTableViewCell.nib(), forCellReuseIdentifier: TeamAnnouncementsTableViewCell.identifier)
        tableView.register(AdminMembersTableViewCell.nib(), forCellReuseIdentifier: AdminMembersTableViewCell.identifier)
        tableView.register(TeamMembersTableViewCell.nib(), forCellReuseIdentifier: TeamMembersTableViewCell.identifier)
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
            cell = tableView.dequeueReusableCell(withIdentifier: TeamColorTableViewCell.identifier, for: indexPath)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
