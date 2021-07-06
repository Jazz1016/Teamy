//
//  TeamController.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class TeamController {
    static let shared = TeamController()
    
    var teams: [Team] = []
    let db = Firestore.firestore()
    let sports: [String] = ["Basketball", "Hockey", "Baseball", "Soccer", "Football"]
    
    ///Fetching Team To Display on HomeVC
    func fetchTeamsForUser(teamIds: [String], completion: @escaping (Bool) -> Void) {
        teams = []
        var counter = 0
        for i in teamIds {
            print(i)
            let fetchedTeam = db.collection("teams").whereField("teamId", isEqualTo: i)
            
            fetchedTeam.getDocuments { snap, error in
                if snap?.count == 1 {
                    guard let snap = snap else {return}
                    let teamData = snap.documents[0].data()
                    
                    let name = teamData["name"] as? String
                    let teamColor = teamData["teamColor"] as? String
                    let teamSport = teamData["teamSport"] as? String
                    let admins = teamData["admins"] as? Array<String>
                    let members = teamData["members"] as? Array<String>
                    let teamId = teamData["teamId"] as? String
                    let teamCode = teamData["teamCode"] as? String
                    let blocked = teamData["blocked"] as? Array<String>
                    let teamDescription = teamData["teamDesc"] as? [String:String] ?? [:]
                    let teamImageString = teamData["teamImage"] as? String
                    
                    guard let name1 = name,
                          let teamSport1 = teamSport,
                          let admins1 = admins,
                          let teamId1 = teamId,
                          let members1 = members,
                          let teamCode1 = teamCode,
                          let blocked1 = blocked,
                          let teamColor1 = teamColor,
                          let teamImage = teamImageString
                          else {return}
                    
                    print(teamDescription)
                    var leagueName: String = ""
                    var detail: String = ""
                    for i in teamDescription {
                        if i.key == "leagueName" {
                            leagueName = i.value
                        } else if i.key == "detail" {
                            detail = i.value
                        }
                    }
                    
                    let teamDescToPass = TeamDescription(leagueName: leagueName, detail: detail)
                    
                    let teamToAdd = Team(name: name1, teamColor: teamColor1, teamSport: teamSport1, admins: admins1, members: members1, blocked: blocked1, teamDesc: teamDescToPass, teamId: teamId1, teamCode: teamCode1, teamImage: teamImage)
                    
                    self.teams.append(teamToAdd)
                    counter += 1
                    if counter == teamIds.count {
                        completion(true)
                        return
                    }
                }
            }
        }
    }
    
    ///Create's team and one nested Contact document
    func createTeam(team: Team, contact: Contact, completion: @escaping (Result<Bool, TeamError>) -> Void) {
        
        let teamRef = db.collection("teams").document(team.teamId)
        
        teamRef.setData([
            "name" : team.name,
            "teamColor" : team.teamColor,
            "teamSport" : team.teamSport,
            "teamDescription" : ([
                "detail" : team.teamDesc.detail,
                "leagueName" : team.teamDesc.leagueName
            ]),
            "admins" : team.admins,
            "members" : team.members,
            "blocked" : team.blocked,
            "teamId" : team.teamId,
            "teamCode" : team.teamCode,
            "teamImage" : team.teamImage
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
        
        let baseAnnouncement = Announcement(title: "No Announcements", details: "No announcements at this time")
        
        db.collection("teams").document(team.teamId).collection("announcements").document(baseAnnouncement.announcementId).setData([
            "title" : baseAnnouncement.title,
            "details" : baseAnnouncement.details,
            "announcementId" : baseAnnouncement.announcementId
        ])
        
        completion(.success(true))
    }
    
    ///Edit's existing team
    func editTeam(oldTeam: Team, team: Team) {
        guard let teamIndex = teams.firstIndex(of: oldTeam) else {return}
        
        db.collection("teams").document(team.teamId).setData([
            "name" : team.name,
            "teamColor" : team.teamColor,
            "teamSport" : team.teamSport,
            "teamDescription" : ([
                "detail" : team.teamDesc.detail,
                "leagueName" : team.teamDesc.leagueName
            ]),
            "admins" : team.admins,
            "members" : team.members,
            "blocked" : team.blocked,
            "teamId" : team.teamId,
            "teamCode" : team.teamCode,
            "teamImage" : team.teamImage
        ])
        teams[teamIndex] = team
        EventController.shared.team = team
    }
    
    ///Adds user to team's members array when entering team code
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
    
    ///Deletes team Document
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
    
    func uploadTeamPhoto(image: UIImage) {
        let storageRef = Storage.storage().reference().child("myImage.jpg")
        if let uploadData = image.jpegData(compressionQuality: 0.75) {
            storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                if let error = error {
                    print("")
                }
                print(metaData)
                let size = metaData?.size
                storageRef.downloadURL { (url, error) in
                    guard let downloadurl = url else {return}
                    print(downloadurl)
                }
            }
        }
    }
}//End of class
