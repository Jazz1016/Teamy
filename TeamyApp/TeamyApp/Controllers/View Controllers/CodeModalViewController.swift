//
//  CodeModalViewController.swift
//  TeamyApp
//
//  Created by James Lea on 7/1/21.
//

import UIKit

class CodeModalViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var teamCodeLabel: UILabel!
    @IBOutlet weak var teamCodeView: UIView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let team = EventController.shared.team else {return}
        
        teamCodeLabel.text = team.teamCode
    }
    
    // MARK: - Properties
    var randomNumString = "\(Int.random(in: 1...999999))"
    
    // MARK: - Actions
    @IBAction func dismissModalButtonTapped(_ sender: Any) {
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper FNs
    func addZeros(){
        if randomNumString.count < 6 {
            randomNumString = "0" + randomNumString
            print(randomNumString)
            addZeros()
        }
    }
    
    func resetTeamCode(){
        guard let currentTeam = EventController.shared.team
              else {return}
        addZeros()
        let updatedTeam = Team(name: currentTeam.name, teamColor: currentTeam.teamColor, teamSport: currentTeam.teamSport, admins: currentTeam.admins, members: currentTeam.members, blocked: currentTeam.blocked, teamDesc: currentTeam.teamDesc, teamId: currentTeam.teamId, teamCode: randomNumString, teamImage: currentTeam.teamImage)
        
        TeamController.shared.editTeam(oldTeam: currentTeam, team: updatedTeam)
        
        teamCodeLabel.text = randomNumString
    }
    
}//End of class
