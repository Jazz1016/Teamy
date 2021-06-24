//
//  User.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import Foundation

class User: Codable {
    let email: String
    let firstName: String
    let lastName: String
    var teams: [String]
    let userId: String
    
    init(email: String, firstName: String, lastName: String, teams: [String] = [], userId: String){
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.teams = teams
        self.userId = userId
    }
}//End of class
