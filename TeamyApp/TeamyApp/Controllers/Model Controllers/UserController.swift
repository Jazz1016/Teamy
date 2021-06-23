//
//  UserController.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import Foundation
import FirebaseFirestore

class UserController {
    static let shared = UserController()
    
    var user: User?
    
    let db = Firestore.firestore()
    
    func createUser(user: User){
        db.collection("users").document(user.userId).setData([
            "email" : user.email,
            "firstName" : user.firstName,
            "lastName" : user.lastName,
            "invites" : user.invites,
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
                    "invites" : invites,
                    "teams" : teams,
                    "userId" : userId
                ])
            }
        }
    }
    
    func userjoinsTeam(teamCode: String){
        let queriedTeam = db.collection("teams").whereField("teamCode", isEqualTo: teamCode)
        
//        queriedTeam.getDocuments(completion: ``completion: <#FIRQuerySnapshotBlock#>)
    }
}//End of class
