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
        
    }
}//End of class

extension UserManagementViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return UserController.shared.admins.count
        } else if section == 1 {
            return UserController.shared.members.count
        } else if section == 2 {
            return UserController.shared.blocked.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let team = EventController.shared.team else {return []}
        let promoteAction = UITableViewRowAction(style: .default, title: "Promote") { action, indexPath in
            let user = UserController.shared.members[indexPath.row]
            var admins = team.admins
            var members = team.admins
            var memberIndex: Int = 0
            for (i, el) in members.enumerated() {
                if el == user.userId {
                    memberIndex = i
                }
            }
            members.remove(at: memberIndex)
            admins.append(user.userId)
            UserController.shared.admins.append(user)
            UserController.shared.members.remove(at: memberIndex)
            let teamToPass = Team(name: team.name, teamColor: team.teamColor, teamSport: team.teamSport, teamRecord: team.teamRecord, leagueName: team.leagueName, teamBio: team.teamBio, admins: admins, members: members, blocked: team.blocked, teamId: team.teamId, teamCode: team.teamCode, teamImage: team.teamImage)
            TeamController.shared.editTeam(oldTeam: team, team: teamToPass)
            tableView.reloadData()
        }
        let demoteAction = UITableViewRowAction(style: .default, title: "Demote") { action, indexPath in
            let user = UserController.shared.admins[indexPath.row]
            var admins = team.admins
            var members = team.members
            var adminIndex: Int = 0
            for (i, el) in admins.enumerated() {
                if el == user.userId {
                    adminIndex = i
                }
            }
            UserController.shared.members.append(user)
            UserController.shared.admins.remove(at: adminIndex)
            admins.remove(at: adminIndex)
            members.append(user.userId)
            let teamToPass = Team(name: team.name, teamColor: team.teamColor, teamSport: team.teamSport, teamRecord: team.teamRecord, leagueName: team.leagueName, teamBio: team.teamBio, admins: admins, members: members, blocked: team.blocked, teamId: team.teamId, teamCode: team.teamCode, teamImage: team.teamImage)
            TeamController.shared.editTeam(oldTeam: team, team: teamToPass)
            tableView.reloadData()
        }
        let blockAction = UITableViewRowAction(style: .default, title: "Block") { action, indexPath in
            if indexPath.section == 0 {
                ///Admin ---> Blocked
                let user = UserController.shared.members[indexPath.row]
                var admins = team.admins
                var blocked = team.blocked
                var adminIndex: Int = 0
                for (i, el) in admins.enumerated() {
                    if el == user.userId {
                        adminIndex = i
                    }
                }
                UserController.shared.blocked.append(user)
                UserController.shared.admins.remove(at: adminIndex)
                admins.remove(at: adminIndex)
                let teamToPass = Team(name: team.name, teamColor: team.teamColor, teamSport: team.teamSport, teamRecord: team.teamRecord, leagueName: team.leagueName, teamBio: team.teamBio, admins: admins, members: team.members, blocked: blocked, teamId: team.teamId, teamCode: team.teamCode, teamImage: team.teamImage)
                TeamController.shared.editTeam(oldTeam: team, team: teamToPass)
                tableView.reloadData()
            } else {
                ///Member ---> Blocked
                let user = UserController.shared.members[indexPath.row]
                var blocked = team.blocked
                var members = team.members
                var memberIndex: Int = 0
                for (i, el) in members.enumerated() {
                    if el == user.userId {
                        memberIndex = i
                    }
                }
                UserController.shared.blocked.append(user)
                UserController.shared.members.remove(at: memberIndex)
                members.remove(at: memberIndex)
                blocked.append(user.userId)
                let teamToPass = Team(name: team.name, teamColor: team.teamColor, teamSport: team.teamSport, teamRecord: team.teamRecord, leagueName: team.leagueName, teamBio: team.teamBio, admins: team.admins, members: members, blocked: blocked, teamId: team.teamId, teamCode: team.teamCode, teamImage: team.teamImage)
                TeamController.shared.editTeam(oldTeam: team, team: teamToPass)
                tableView.reloadData()
            }
        }
        
        let unblockAction = UITableViewRowAction(style: .default, title: "Unblock") { action, indexPath in
            let user = UserController.shared.blocked[indexPath.row]
            var blocked = team.blocked
            var members = team.members
            let blockedIndex = blocked.firstIndex { i in
                if i == user.userId {
                    return true
                } else {
                    return false
                }
            }
            UserController.shared.members.append(user)
            UserController.shared.blocked.remove(at: blockedIndex!)
            blocked.remove(at: blockedIndex!)
            members.append(user.userId)
            let teamToPass = Team(name: team.name, teamColor: team.teamColor, teamSport: team.teamSport, teamRecord: team.teamRecord, leagueName: team.leagueName, teamBio: team.teamBio, admins: team.admins, members: members, blocked: blocked, teamId: team.teamId, teamCode: team.teamCode, teamImage: team.teamImage)
            TeamController.shared.editTeam(oldTeam: team, team: teamToPass)
            tableView.reloadData()
        }
        promoteAction.backgroundColor = .systemBlue
        unblockAction.backgroundColor = .systemBlue
        demoteAction.backgroundColor = .systemOrange
        blockAction.backgroundColor = .systemRed
        if indexPath.section == 0 {
            if UserController.shared.user!.userId == UserController.shared.admins[indexPath.row].userId {
                return []
            } else {
                return [demoteAction, blockAction]
            }
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
