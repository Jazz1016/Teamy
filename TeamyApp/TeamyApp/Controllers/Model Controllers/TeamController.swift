//
//  TeamController.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import Foundation
import FirebaseFirestore

protocol reloadHomeTableView: AnyObject {
    func updateTableView()
}

class TeamController {
    static let shared = TeamController()
    
    var teams: [Team] = []
    let db = Firestore.firestore()
    weak var delegate: reloadHomeTableView?
    
    func fetchTeamsForUser(teamIds: [String]) {
        self.teams = []
        for i in teamIds {
            let fetchedTeam = db.collection("teams").whereField("teamId", isEqualTo: i)
            
            fetchedTeam.getDocuments { snap, error in
                if snap?.count == 1 {
                    guard let snap = snap else {return}
                    let teamData = snap.documents[0].data()
                    
                    let name = teamData["name"] as? String
                    let admins = teamData["admins"] as? Array<String>
                    let members = teamData["members"] as? Array<String>
                    let teamId = teamData["teamId"] as? String
                    let teamCode = teamData["teamCode"] as? String
                    
                    guard let name1 = name,
                          let admins1 = admins,
                          let teamId1 = teamId,
                          let members1 = members,
                          let teamCode1 = teamCode
                          else {return}
                    
                    let teamToAdd = Team(name: name1, admins: admins1, members: members1, teamId: teamId1, teamCode: teamCode1)
                    print(self.teams)
                    self.teams.append(teamToAdd)
                    self.delegate?.updateTableView()
                }
            }
        }
        print(self.teams, "2")
    }
    
    func createTeam(team: Team){
        
        let teamRef = db.collection("teams").document(team.teamId)
        teamRef.setData([
            "name" : team.name,
            "admins" : team.admins,
            "members" : team.members,
            "teamId" : team.teamId,
            "teamCode" : team.teamCode
        ])
        teams.append(team)
    }
    
    func addTeamToUser(userId: String, teamId: String){
        let query = db.collection("users").whereField("userId", isEqualTo: userId)
        query.getDocuments { snap, error in
            
            guard let snap = snap else {return}
            
            if snap.count == 1 {
                let userData = snap.documents[0].data()
                
                let firstName = userData["firstName"] as? String
                let lastName = userData["lastName"] as? String
                var teams = userData["teams"] as? Array ?? []
                let userId = userData["userId"] as? String
                
                teams.append(teamId)
                
                self.db.collection("users").document(userId!).setData([
                    "firstName" : firstName,
                    "lastName" : lastName,
                    "teams" : teams,
                    "userId" : userId
                ])
            } else {
                return
            }
        }
    }
    
}//End of class
