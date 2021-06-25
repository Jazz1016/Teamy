//
//  TeamController.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol reloadHomeTableView: AnyObject {
    func updateTableView()
}

class TeamController {
    static let shared = TeamController()
    
    var teams: [Team] = []
    let db = Firestore.firestore()
    weak var delegate: reloadHomeTableView?
    let sports: [String] = ["Basketball", "Hockey", "Baseball", "Soccer", "Football"]
    let colors: [String] = ["Blue", "Red", "Yellow", "Silver"]
    
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
                    let blocked = teamData["blocked"] as? Array<String>
                    let teamDescription = teamData["teamDescription"] as? TeamDescription
                    let teamColor = teamData["teamColor"] as? String
                    
                    guard let name1 = name,
                          let admins1 = admins,
                          let teamId1 = teamId,
                          let members1 = members,
                          let teamCode1 = teamCode,
                          let blocked1 = blocked,
                          let teamDescript1 = teamDescription,
                          let teamColor1 = teamColor
                          else {return}
                    
                    let teamToAdd = Team(name: name1, teamColor: teamColor1, admins: admins1, members: members1, blocked: blocked1, teamDesc: teamDescript1, teamId: teamId1, teamCode: teamCode1)
                    print(self.teams)
                    self.teams.append(teamToAdd)
                    self.delegate?.updateTableView()
                }
            }
        }
        print(self.teams, "2")
    }
    
    func createTeam(team: Team, contact: Contact, completion: @escaping (Result<Bool, TeamError>) -> Void){
        
        let teamRef = db.collection("teams").document(team.teamId)
        
        teamRef.setData([
            "name" : team.name,
            "admins" : team.admins,
            "members" : team.members,
            "teamId" : team.teamId,
            "teamCode" : team.teamCode,
            "teamDescription" : ([
                "detail" : team.teamDesc.detail,
                "leagueName" : team.teamDesc.leagueName
            ]),
        ])
        teams.append(team)
        // JAMLEA: I'll be adding optional contact when user creates a team once I get the outlets for createNewTeamVC
        if contact.contactName.count > 0 {
            db.collection("teams").document(team.teamId).collection("contacts").document(contact.contactId).setData([
                "contactName" : contact.contactName,
                "contactType" : contact.contactType,
                "contactInfo" : contact.contactInfo,
                "contactId" : contact.contactId
            ])
        }
        completion(.success(true))
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
    
    func deleteTeam(team: Team) {
        guard let index = teams.firstIndex(of: team) else { return }
        teams.remove(at: index)
        
        db.collection("teams").document(team.teamId).delete() { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
}//End of class
