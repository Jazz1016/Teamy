//
//  TeamController.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import Foundation
import FirebaseFirestore

class TeamController {
    static let shared = TeamController()
    
    var teams: [Team] = []
    let db = Firestore.firestore()
    
    func fetchTeamsForUser(teamIds: [String]) {
        for i in teamIds {
            self.teams = []
            let fetchedTeam = db.collection("teams").whereField("teamId", isEqualTo: i)
            
            fetchedTeam.getDocuments { snap, error in
                if snap?.count == 1 {
                    guard let snap = snap else {return}
                    let teamData = snap.documents[0].data()
                    
                    let name = teamData["name"] as? String
                    let admins = teamData["admins"] as? Array<String>
                    let members = teamData["members"] as? Array<String>
                    let teamId = teamData["teamId"] as? String
                    
                    guard let name1 = name,
                          let admins1 = admins,
                          let teamId1 = teamId,
                          let members1 = members else {return}
                    
                    let teamToAdd = Team(name: name1, admins: admins1, members: members1, teamId: teamId1)
                    
                    self.teams.append(teamToAdd)
                    
                }
            }
        }
    }
    
    func createTeam(team: Team){
        let teamToAdd: Team = team
        
        let teamRef = db.collection("teams").document(teamToAdd.teamId)
        teamRef.setData([
            "name" : team.name,
            "admins" : team.admins,
            "members" : team.members,
            "teamId" : team.teamId
        ])
        teams.append(teamToAdd)
    }
    
    func addTeamToUser(userId: String, teamId: String){
        let query = db.collection("users").whereField("userId", isEqualTo: userId)
        query.getDocuments { snap, error in
            
            guard let snap = snap else {return}
            
            if snap.count == 1 {
                let userData = snap.documents[0].data()
                
                let firstName = userData["firstName"] as? String
                let lastName = userData["lastName"] as? String
                let invites = userData["invites"] as? Array<String>
                var teams = userData["teams"] as? Array ?? []
                let userId = userData["userId"] as? String
                
                teams.append(teamId)
                
                self.db.collection("users").document(userId!).setData([
                    "firstName" : firstName,
                    "lastName" : lastName,
                    "invites" : invites,
                    "teams" : teams,
                    "userId" : userId
                ])
            } else {
                return
            }
        }
    }
    
    func inviteUserToTeam(userEmail: String, teamId: String){
        var userQueried = db.collection("users").whereField("email", isEqualTo: userEmail)
        userQueried.getDocuments { snap, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            
            guard let snap = snap else {return}
            
            if snap.count == 1 {
                let userData = snap.documents[0].data()
                
                let email = userData["email"] as? String
                let firstName = userData["firstName"] as? String
                let lastName = userData["lastName"] as? String
                var invites = userData["invites"] as? Array<String> ?? []
                let teams = userData["teams"] as? Array<String> ?? []
                let userId =  userData["userId"] as? String
                
                invites.append(teamId)
                
                
                self.db.collection("users").document(userId!).setData([
                
                    "email" : email,
                    "firstName" : firstName,
                    "lastName" : lastName,
                    "invites" : invites,
                    "teams" : teams,
                    "userId" : userId
                ])
                
            }
        }
    }
    
}//End of class
