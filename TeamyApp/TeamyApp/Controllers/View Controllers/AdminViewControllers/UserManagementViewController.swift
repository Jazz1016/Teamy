//
//  UserManagementViewController.swift
//  TeamyApp
//
//  Created by James Lea on 7/5/21.
//

import UIKit

class UserManagementViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var accessTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessTableView.dataSource = self
        accessTableView.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let team = EventController.shared.team else {return}
        UserController.shared.fetchUsers(userIds: team.admins, access: "admin") { result in
            self.accessTableView.reloadData()
        }
        UserController.shared.fetchUsers(userIds: team.members, access: "member") { result in
            self.accessTableView.reloadData()
        }
        UserController.shared.fetchUsers(userIds: team.blocked, access: "blocked") { result in
            self.accessTableView.reloadData()
        }
    }
}//End of class

extension UserManagementViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let team = EventController.shared.team else {return 0}
        if section == 0 {
            return team.admins.count
        } else if section == 1 {
            return team.members.count
        } else if section == 2 {
            return team.blocked.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let team = EventController.shared.team else {return []}
        let promoteAction = UITableViewRowAction(style: .default, title: "Promote") { action, indexPath in
            let userId = UserController.shared.members[indexPath.row].userId
            var admins = team.admins
            var members = team.admins
            let memberIndex = members.firstIndex(of: userId)
            members.remove(at: memberIndex!)
            admins.append(userId)
            
//            let teamD = TeamDescription(leagueName: team.teamDesc.leagueName, detail: team.teamDesc.detail)
            
            let teamToPass = Team(name: team.name, teamColor: team.teamColor, teamSport: team.teamSport, teamRecord: team.teamRecord, leagueName: team.leagueName, teamBio: team.teamBio, admins: admins, members: members, blocked: team.blocked, teamId: team.teamId, teamCode: team.teamCode, teamImage: team.teamImage)
            
            TeamController.shared.editTeam(oldTeam: team, team: teamToPass)
        }
        
        let demoteAction = UITableViewRowAction(style: .default, title: "Demote") { action, indexPath in
            let userId = UserController.shared.members[indexPath.row].userId
            var admins = team.admins
            var members = team.members
            let adminIndex = admins.firstIndex(of: userId)
            admins.remove(at: adminIndex!)
            members.append(userId)
            
//            let teamD = TeamDescription(leagueName: team.teamDesc.leagueName, detail: team.teamDesc.detail)
            let teamToPass = Team(name: team.name, teamColor: team.teamColor, teamSport: team.teamSport, teamRecord: team.teamRecord, leagueName: team.leagueName, teamBio: team.teamBio, admins: admins, members: members, blocked: team.blocked, teamId: team.teamId, teamCode: team.teamCode, teamImage: team.teamImage)
            
            TeamController.shared.editTeam(oldTeam: team, team: teamToPass)
        }
        
        let blockAction = UITableViewRowAction(style: .default, title: "Block") { action, indexPath in
            if indexPath.section == 0 {
                let userId = UserController.shared.members[indexPath.row].userId
                var admins = team.admins
                var blocked = team.blocked
                let adminIndex = admins.firstIndex(of: userId)
                admins.remove(at: adminIndex!)
                
//                let teamD = TeamDescription(leagueName: team.teamDesc.leagueName, detail: team.teamDesc.detail)
                let teamToPass = Team(name: team.name, teamColor: team.teamColor, teamSport: team.teamSport, teamRecord: team.teamRecord, leagueName: team.leagueName, teamBio: team.teamBio, admins: admins, members: team.members, blocked: blocked, teamId: team.teamId, teamCode: team.teamCode, teamImage: team.teamImage)
                
                TeamController.shared.editTeam(oldTeam: team, team: teamToPass)
                
            } else {
                let userId = UserController.shared.members[indexPath.row].userId
                var blocked = team.blocked
                var members = team.members
                let memberIndex = members.firstIndex(of: userId)
                members.remove(at: memberIndex!)
                blocked.append(userId)
                
//                let teamD = TeamDescription(leagueName: team.teamDesc.leagueName, detail: team.teamDesc.detail)
                let teamToPass = Team(name: team.name, teamColor: team.teamColor, teamSport: team.teamSport, teamRecord: team.teamRecord, leagueName: team.leagueName, teamBio: team.teamBio, admins: team.admins, members: members, blocked: blocked, teamId: team.teamId, teamCode: team.teamCode, teamImage: team.teamImage)
                
                TeamController.shared.editTeam(oldTeam: team, team: teamToPass)
            }
        }
        
        let unblockAction = UITableViewRowAction(style: .default, title: "Unblock") { action, indexPath in
            let userId = UserController.shared.blocked[indexPath.row].userId
            var blocked = team.blocked
            var members = team.members
            let blockedIndex = blocked.firstIndex(of: userId)
            blocked.remove(at: blockedIndex!)
            members.append(userId)
            
            let teamToPass = Team(name: team.name, teamColor: team.teamColor, teamSport: team.teamSport, teamRecord: team.teamRecord, leagueName: team.leagueName, teamBio: team.teamBio, admins: team.admins, members: members, blocked: blocked, teamId: team.teamId, teamCode: team.teamCode, teamImage: team.teamImage)
            
            TeamController.shared.editTeam(oldTeam: team, team: teamToPass)
        }
        
        promoteAction.backgroundColor = .systemBlue
        unblockAction.backgroundColor = .systemBlue
        demoteAction.backgroundColor = .systemOrange
        blockAction.backgroundColor = .systemRed
        
        if indexPath.section == 0 {
            return [demoteAction, blockAction]
        } else if indexPath.section == 1 {
            return [promoteAction, blockAction]
        } else {
            return [unblockAction]
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Admins"
        } else if section == 1 {
            return "Members"
        } else {
            return "Blocked"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userEditCell", for: indexPath) as? UserTableViewCell
            if UserController.shared.admins.count > 0 {
                let user = UserController.shared.admins[indexPath.row]
                let access = "admin"
                cell?.access = access
                cell?.user = user
            }
            return cell ?? UITableViewCell()
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userEditCell", for: indexPath) as? UserTableViewCell
            if UserController.shared.members.count > 0 {
                let user = UserController.shared.members[indexPath.row]
                let access = "member"
                cell?.access = access
                cell?.user = user
            }
            return cell ?? UITableViewCell()
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userEditCell", for: indexPath) as? UserTableViewCell
            if UserController.shared.blocked.count > 0 {
                let user = UserController.shared.blocked[indexPath.row]
                let access = "blocked"
                cell?.access = access
                cell?.user = user
            }
            return cell ?? UITableViewCell()
        }
        return UITableViewCell()
    }
}//End of extension
