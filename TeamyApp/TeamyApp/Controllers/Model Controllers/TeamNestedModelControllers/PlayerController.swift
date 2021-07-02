//
//  PlayerController.swift
//  TeamyApp
//
//  Created by James Lea on 6/24/21.
//

import Foundation
import Firebase



class PlayerController {
    static let shared = PlayerController()
    
    var players: [Player] = []
    
    let db = Firestore.firestore()
    
    // MARK: - CRUD
    func createPlayer(player: Player, teamId: String){
        
        db.collection("teams").document(teamId).collection("players").document(player.playerId).setData([
            "name" : player.name,
            "role" : player.role,
            "jerseyNumber" : player.jerseyNumber,
            "playerId" : player.playerId
        ])
        players.append(player)
    }
    
    func updatePlayer(oldPlayer: Player, player: Player, teamId: String, completion: @escaping (Bool) -> Void) {
        guard let index = players.firstIndex(of: oldPlayer) else {return}
        
        db.collection("teams").document(teamId).collection("players").document(player.playerId).setData([
            "name" : player.name,
            "role" : player.role,
            "jerseyNumber" : player.jerseyNumber,
            "playerId" : player.playerId
        ])
        
        players[index] = player
        completion(true)
    }
    
    
    func fetchPlayers(teamId: String){
        db.collection("teams").document(teamId).collection("players").addSnapshotListener { snap, error in
//            if let error = error {
//                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//                return
//            }
            
            if let snap = snap {
                self.players = []
                for doc in snap.documents {
                    
                    
                    let playerData = doc.data()
                    guard let name = playerData["name"] as? String,
                          
                          let role = playerData["role"] as? String,
                          
                          let jerseyNumber = playerData["jerseyNumber"] as? String,
                          
                          let playerId = playerData["playerId"] as? String else {return}
                    
                    let player = Player(name: name, role: role, jerseyNumber: jerseyNumber, playerId: playerId)
                    
                    self.players.append(player)
                }
            }
        }
    }
    
    func deletePlayer(player: Player, teamId: String){
        guard let index = players.firstIndex(of: player) else {return}
        
        players.remove(at: index)
        db.collection("teams").document(teamId).collection("players").document(player.playerId).delete() {
            error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Player successfully removed")
            }
        }
    }
    
}//End of class
