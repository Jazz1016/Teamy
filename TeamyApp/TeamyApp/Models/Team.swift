//
//  Team.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import Foundation

class Team: Codable {
    let name: String
    var teamColor: String
    let teamSport: String
    let teamRecord: String
    let leagueName: String
    let teamBio: String
    var admins: [String]
    var members: [String]
    var blocked: [String]
    let teamId: String
    let teamCode: String
    var teamImage: String
    
    init(name: String, teamColor: String, teamSport: String, teamRecord: String, leagueName: String, teamBio: String, admins: [String], members: [String], blocked: [String],  teamId: String = UUID().uuidString, teamCode: String, teamImage: String){
        self.name = name
        self.teamColor = teamColor
        self.teamSport = teamSport
        self.leagueName = leagueName
        self.teamRecord = teamRecord
        self.teamBio = teamBio
        self.admins = admins
        self.members = members
        self.blocked = blocked
        self.teamId = teamId
        self.teamCode = teamCode
        self.teamImage = teamImage
    }
}//End of class

extension Team: Equatable {
    static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.teamId == rhs.teamId
    }
}//End of extension

class TeamDescription: Codable {
    let leagueName: String
    let detail: String
    init(leagueName: String, detail: String){
        self.leagueName = leagueName
        self.detail = detail
    }
}//End of class
