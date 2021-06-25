//
//  Player.swift
//  TeamyApp
//
//  Created by James Lea on 6/24/21.
//

import Foundation

class Player {
    let name: String
    let role: String
    let jerseyNumber: String
    let playerId: String
    init(name: String, role: String, jerseyNumber: String, playerId: String = UUID().uuidString){
        self.name = name
        self.role = role
        self.jerseyNumber = jerseyNumber
        self.playerId = playerId
    }
}

extension Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.playerId == rhs.playerId
    }
}//End of extension
