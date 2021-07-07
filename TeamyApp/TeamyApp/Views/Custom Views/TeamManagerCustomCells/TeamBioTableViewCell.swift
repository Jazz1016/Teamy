//
//  TeamBioTableViewCell.swift
//  TeamyApp
//
//  Created by anthony byrd on 6/29/21.
//

import UIKit

class TeamBioTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var teamBioLabel: UILabel!
    @IBOutlet weak var editTeamBioTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        teamBio()
        initializeViews()
    }
    
    //MARK: - Properties
    static let identifier = "TeamBioTableViewCell"
    
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        updateTeamBio()
    }
    
    //MARK: - Methods
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func teamBio() {
        guard let team = EventController.shared.team else { return }
        teamBioLabel.text = team.teamBio
        editTeamBioTextField.text = team.teamBio
    }
    
    func initializeViews() {
        editTeamBioTextField.isHidden = true
        saveButton.isHidden = true
    }
    
    func updateForEdit() {
        teamBioLabel.isHidden.toggle()
        editTeamBioTextField.isHidden.toggle()
        saveButton.isHidden.toggle()
    }
    
    func updateTeamBio() {
        guard let currentTeam = EventController.shared.team else { return }
        
        let updatedTeam = Team(name: currentTeam.name, teamColor: currentTeam.teamColor, teamSport: currentTeam.teamSport, teamRecord: currentTeam.teamRecord, leagueName: currentTeam.leagueName, teamBio: editTeamBioTextField.text ?? "", admins: currentTeam.admins, members: currentTeam.members, blocked: currentTeam.blocked, teamId: currentTeam.teamId, teamCode: currentTeam.teamCode, teamImage: currentTeam.teamImage)
        
        TeamController.shared.editTeam(oldTeam: currentTeam, team: updatedTeam)
        
        teamBioLabel.text = updatedTeam.teamBio
        self.updateForEdit()
    }
}
