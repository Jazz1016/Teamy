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
    var admins: [User] = []
    var members: [User] = []
    var blocked: [User] = []
    
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
    
    func fetchUsers(userIds: [String], access: String, completion: @escaping (Bool) -> Void) {
        if access == "admin" {
            self.admins = []
        } else if access == "member" {
            self.members = []
        } else if access == "blocked" {
            self.blocked = []
        }
        var counter = 0
        for i in userIds {
            
            let fetchedUser = db.collection("users").whereField("userId", isEqualTo: i)
            fetchedUser.getDocuments { snap, error in
                
                if snap?.count == 1 {
                    guard let snap = snap else {return}
                    let userData = snap.documents[0].data()
                    
                    let email = userData["email"] as? String
                    let firstName = userData["firstName"] as? String
                    let lastName = userData["lastName"] as? String
                    let userId = userData["userId"] as? String
                    
                    guard let email1 = email,
                          let firstName1 = firstName,
                          let lastName1 = lastName,
                          let id = userId else {return}
                    
                    let userToPass = User(email: email1, firstName: firstName1, lastName: lastName1, teams: [], userId: id)
                    
                    if access == "admin" {
                        self.admins.append(userToPass)
                    } else if access == "member" {
                        self.members.append(userToPass)
                    } else if access == "blocked" {
                        self.blocked.append(userToPass)
                    }
                    counter += 1
                    if counter == userIds.count {
                        completion(true)
                        return
                    }
                }
            }
        }
    }
    
    func updateUser(user: User) {
        db.collection("users").document(user.userId).setData([
            "email" : user.email,
            "firstName" : user.firstName,
            "lastName" : user.lastName,
            "teams" : user.teams,
            "userId" : user.userId
        ], merge: true)
        
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
    
    func deleteUser(completion: @escaping (Result<Bool, Error>) -> Void) {
        let user = Auth.auth().currentUser
        
        user?.delete(completion: { error in
            if let error = error {
                print("And error has occured")
                completion(.failure(error))
            } else {
                print("Account successfully deleted")
                completion(.success(true))
            }
        })
    }
    
    func deleteUserInfo() {
        guard let user = user else {return}
        db.collection("users").document(user.userId).delete() { error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                print("Couldn't delete user info")
            } else {
                print("Successfully deleted user info")
            }
        }
    }
    
    func userjoinsTeam(teamCode: String, userId: String, completion: @escaping (Bool) -> Void){
        
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
                let teamRecord = teamData["teamRecord"] as? String
                let leagueName = teamData["leagueName"] as? String
                let teamBio = teamData["teamBio"] as? String
                let admins = teamData["admins"] as? Array<String>
                var members = teamData["members"] as? Array<String>
                let blocked = teamData["blocked"] as? Array<String>
                let teamId = teamData["teamId"] as? String
                let teamCode = teamData["teamCode"] as? String
                
                
                
                for i in blocked! {
                    if i == userId {
                        completion(false)
                        return
                    }
                }
                
                for i in admins! {
                    if i == userId {
                        completion(false)
                        return
                    }
                }
                
                for i in members! {
                    if i == userId{
                        completion(false)
                        return
                    }
                }
                
                
                members?.append(userId)
                self.user?.teams.append(teamId!)
                self.db.collection("teams").document(teamId!).setData([
                    "name" : name ?? "error",
                    "teamColor" : teamColor ?? "error",
                    "teamSport" : teamSport ?? "error",
                    "teamRecord" : teamRecord ?? "error",
                    "leagueName" : leagueName ?? "error",
                    "teamBio" : teamBio ?? "error",
                    "admins" : admins ?? [],
                    "members" : members ?? [],
                    "blocked" : blocked ?? [],
                    "teamId" : teamId ?? "error",
                    "teamCode" : teamCode ?? "error"
                ], merge: true)
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
                            completion(true)
                        case .failure(let error):
                            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func blockUserFromTeam(teamId: String, userId: String){
        let queriedUser = db.collection("users").whereField("userId", isEqualTo: userId)
        
        queriedUser.getDocuments { snap, error in
//            if let error = error {
//                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//            }
            
            guard let snap = snap else {return}
            if snap.count == 1 {
                let userData = snap.documents[0].data()
                let email = userData["email"] as? String
                let firstName = userData["firstName"] as? String
                let lastName = userData["lastName"] as? String
                var teams = userData["teams"] as? Array<String> ?? []
                let userId = userData["userId"] as? String
                
                var index = 0
                
                for (i, el) in teams.enumerated() {
                    
                    if el == teamId {
                        index = i
                    }
                }
                
                teams.remove(at: index)
                
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
}//End of class
