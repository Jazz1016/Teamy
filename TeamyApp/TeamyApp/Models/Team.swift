//
//  Team.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import Foundation

class Team: Codable {
    let name: String
    let teamColor: String
    let teamDesc: TeamDescription
    var admins: [String]
    var members: [String]
    var blocked: [String]
    let teamId: String
    let teamCode: String
    
    init(name: String, teamColor: String, admins: [String], members: [String], blocked: [String], teamDesc: TeamDescription, teamId: String = UUID().uuidString, teamCode: String){
        self.name = name
        self.teamColor = teamColor
        self.teamDesc = teamDesc
        self.admins = admins
        self.members = members
        self.blocked = blocked
        self.teamId = teamId
        self.teamCode = teamCode
    }
}

extension Team: Equatable {
    static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.teamId == rhs.teamId
    }
}

class TeamDescription: Codable {
    let leagueName: String
    let detail: String
    init(leagueName: String, detail: String){
        self.leagueName = leagueName
        self.detail = detail
    }
}
