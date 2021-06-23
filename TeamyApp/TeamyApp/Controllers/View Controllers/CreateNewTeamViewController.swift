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
        
        let newTeam = Team(name: name, admins: [], members: [], teamCode: randomNumString)
        TeamController.shared.addTeamToUser(userId: userId, teamId: newTeam.teamId)
        TeamController.shared.createTeam(team: newTeam)
    }
    
}
