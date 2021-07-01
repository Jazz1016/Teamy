//
//  UserController.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import Foundation
import FirebaseFirestore
import Firebase

class UserController {
    static let shared = UserController()
    
    var user: User?
    
    let db = Firestore.firestore()
    
    func createUser(user: User){
        db.collection("users").document(user.userId).setData([
            "email" : user.email,
            "firstName" : user.firstName,
            "lastName" : user.lastName,
            "teams" : user.teams,
            "userId" : user.userId
        ])
        self.user = user
    }
    
    func fetchUser(userId: String, completion: @escaping (Result<User, UserError>) -> Void){
        let userQueried = db.collection("users").whereField("userId", isEqualTo: userId)
        userQueried.getDocuments { snap, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            guard let snap = snap else {return}
            
            if snap.count == 1 {
                let userData = snap.documents[0].data()
                
                let email = userData["email"] as? String ?? ""
                let firstName = userData["firstName"] as? String ?? ""
                let lastName = userData["lastName"] as? String ?? ""
                let teams = userData["teams"] as? Array<String> ?? []
                let userId = userData["userId"] as? String ?? ""
                
                let userToReturn = User(email: email, firstName: firstName, lastName: lastName, teams: teams, userId: userId)
                completion(.success(userToReturn))
            } else {
                completion(.failure(.noData))
                return}
        }
        
    }
    
    func updateUser(firstName: String, lastName: String) {
        let changeRequset = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequset?.displayName = "\(firstName) \(lastName)"
        changeRequset?.commitChanges(completion: { error in
            if let error = error {
                print("An error has occured")
            } else {
                print("Account successfully updateds")
            }
        })
        
        
    }
    
    func updatePassword(password: String) {
        Auth.auth().currentUser?.updatePassword(to: password, completion: { error in
            if let error = error {
                print("An error has occured")
            } else {
                print("Account successfully updated")
            }
        })
    }
    
    func deleteUser() {
        let user = Auth.auth().currentUser
        
        user?.delete(completion: { error in
            if let error = error {
                print("And error has occured")
            } else {
                print("Accounte successfully deleted")
            }
        })
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
                
                let userId = userData["userId"] as? String
                
                
                invites.append(teamId)
                
                
                self.db.collection("users").document(userId!).setData([
                    
                    "email" : email,
                    "firstName" : firstName,
                    "lastName" : lastName,
                    "teams" : teams,
                    "userId" : userId
                ])
            }
        }
    }
    
    func userjoinsTeam(teamCode: String, userId: String){
        
        let queriedTeam = db.collection("teams").whereField("teamCode", isEqualTo: teamCode)
        queriedTeam.getDocuments { snap, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            
            guard let snap = snap else {return}
            if snap.count == 1 {
                let teamData = snap.documents[0].data()
                let name = teamData["name"] as? String
                let teamColor = teamData["teamColor"] as? String
                let teamSport = teamData["teamSport"] as? String
                let teamDesc = teamData["teamDescription"] as? [String:String] ?? [:]
                let admins = teamData["admins"] as? Array<String>
                var members = teamData["members"] as? Array<String>
                let blocked = teamData["blocked"] as? Array<String>
                let teamId = teamData["teamId"] as? String
                let teamCode = teamData["teamCode"] as? String
                
                var leagueName: String = ""
                var detail: String = ""
                for i in teamDesc {
                    if i.key == "leagueName" {
                        leagueName = i.value
                    } else if i.key == "detail"{
                        detail = i.value
                    }
                }
                
                members?.append(userId)
                self.user?.teams.append(teamId!)
                self.db.collection("teams").document(teamId!).setData([
                    "name" : name ?? "error",
                    "teamColor" : teamColor ?? "error",
                    "teamSport" : teamSport ?? "error",
                    "teamDesc" : ([
                        "leagueName" : leagueName,
                        "detail" : detail
                    ]),
                    "admins" : admins ?? [],
                    "members" : members ?? [],
                    "blocked" : blocked ?? [],
                    "teamId" : teamId ?? "error",
                    "teamCode" : teamCode ?? "error"
                ])
                DispatchQueue.main.async {
                    self.fetchUser(userId: userId) { result in
                        switch result {
                        case .success(let user):
                            var userTeams = user.teams
                            userTeams.append(teamId!)
                            self.db.collection("users").document(user.userId).setData([
                                "email" : user.email,
                                "firstName" : user.firstName,
                                "lastName" : user.lastName,
                                "teams" : userTeams,
                                "userId" : user.userId
                            ])
                        case .failure(let error):
                            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        }
                    }
                }
            }
        }
    }
}//End of class
