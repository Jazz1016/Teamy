//
//  Team.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import Foundation

class Team {
    let name: String
    let admins: [String]
    let members: [String]
    let blocked: [String]
    let teamId: String
    let teamCode: String
    
    init(name: String, admins: [String], members: [String], blocked: [String], teamId: String = UUID().uuidString, teamCode: String){
        self.name = name
        self.admins = admins
        self.members = members
        self.blocked = blocked
        self.teamId = teamId
        self.teamCode = teamCode
    }
}
