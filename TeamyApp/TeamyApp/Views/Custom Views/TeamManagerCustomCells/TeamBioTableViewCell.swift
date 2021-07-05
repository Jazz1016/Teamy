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
        teamBioLabel.text = team.teamDesc.detail
        editTeamBioTextField.text = team.teamDesc.detail
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
        
        var updatedTeamDesc = TeamDescription(leagueName: currentTeam.teamDesc.leagueName, detail: editTeamBioTextField.text ?? "")
        
        let updatedTeam = Team(name: currentTeam.name, teamColor: currentTeam.teamColor, teamSport: currentTeam.teamSport, admins: currentTeam.admins, members: currentTeam.members, blocked: currentTeam.blocked, teamDesc: updatedTeamDesc, teamId: currentTeam.teamId, teamCode: currentTeam.teamCode, teamImage: currentTeam.teamImage)
        
        TeamController.shared.editTeam(oldTeam: currentTeam, team: updatedTeam)
        
        teamBioLabel.text = updatedTeam.teamDesc.detail
        self.updateForEdit()
    }
}
