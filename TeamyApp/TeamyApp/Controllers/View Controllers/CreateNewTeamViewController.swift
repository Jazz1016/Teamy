//
//  CreateNewTeamViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/21/21.
//

import UIKit
import FirebaseAuth

class CreateNewTeamViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var teamNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Properties
    var randomNumString = "\(Int.random(in: 1...999999))"
    
    ///Creates a new team and adds creating user as an admin
    @IBAction func createNewTeamTapped(_ sender: Any) {
        guard let name = teamNameTextField.text,
              let userId = Auth.auth().currentUser?.uid
              else {return}
        
        func addZeros(){
            if randomNumString.count < 6 {
                randomNumString = "0" + randomNumString
                print(randomNumString)
                addZeros()
            }
        }
        addZeros()
        
        let defaultAdmin = [userId]
        
        let teamDescript = TeamDescription(leagueName: "", detail: "")
        
        let newTeam = Team(name: name, teamColor: "blue", admins: defaultAdmin, members: [], blocked: [], teamDesc: teamDescript, teamId: UUID().uuidString, teamCode: randomNumString)
        TeamController.shared.addTeamToUser(userId: userId, teamId: newTeam.teamId)
        
        TeamController.shared.createTeam(team: newTeam) { result in
            print("new team \(newTeam.name) has been created")
        }
    }
}
