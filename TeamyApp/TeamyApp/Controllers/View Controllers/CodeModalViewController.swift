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
    @IBOutlet weak var resetCodeButton: UIButton!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamCodeView.layer.cornerRadius = 15
        resetCodeButton.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let team = EventController.shared.team else {return}
        resetCodeButton.isHidden = true
        teamCodeLabel.text = team.teamCode
        
        if EventController.shared.isAdmin {
            resetCodeButton.isHidden = false
        }
    }
    
    // MARK: - Properties
    var randomNumString = "\(Int.random(in: 1...999999))"
    
    // MARK: - Actions
    @IBAction func dismissModalButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetCodeButtonTapped(_ sender: Any) {
        resetTeamCode()
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
        guard let currentTeam = EventController.shared.team else {return}
        addZeros()
        let updatedTeam = Team(name: currentTeam.name, teamColor: currentTeam.teamColor, teamSport: currentTeam.teamSport, teamRecord: currentTeam.teamRecord, leagueName: currentTeam.leagueName, teamBio: currentTeam.teamBio, admins: currentTeam.admins, members: currentTeam.members, blocked: currentTeam.blocked, teamId: currentTeam.teamId, teamCode: randomNumString, teamImage: currentTeam.teamImage)
        
        TeamController.shared.editTeam(oldTeam: currentTeam, team: updatedTeam)
        
        teamCodeLabel.text = randomNumString
        randomNumString = "\(Int.random(in: 1...999999))"
    }
    
}//End of class
