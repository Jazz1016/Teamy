//
//  TeamNameTableViewCell.swift
//  TeamyApp
//
//  Created by anthony byrd on 6/29/21.
//

import UIKit

class TeamNameTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var editTeamNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    //MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        
        teamName()
        initializeViews()
    }
    
    //MARK: - Properties
    static let identifier = "TeamNameTableViewCell"
    
    //MARK: - Action
    @IBAction func saveButtonTapped(_ sender: Any) {
        updateTeamName()
    }
    
    //MARK: - Methods
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func teamName() {
        guard let team = EventController.shared.team else { return }
        teamNameLabel.text = team.name
        editTeamNameTextField.text = team.name
    }
    
    func initializeViews() {
        editTeamNameTextField.isHidden = true
        saveButton.isHidden = true
    }
    
    func updateForEdit() {
        teamNameLabel.isHidden.toggle()
        editTeamNameTextField.isHidden.toggle()
        saveButton.isHidden.toggle()
    }
    
    func updateTeamName() {
        guard let currentTeam = EventController.shared.team else { return }
        
        let updatedTeam = Team(name: editTeamNameTextField.text ?? "", teamColor: currentTeam.teamColor, teamSport: currentTeam.teamSport, teamRecord: currentTeam.teamRecord, leagueName: currentTeam.leagueName, teamBio: currentTeam.teamBio, admins: currentTeam.admins, members: currentTeam.members, blocked: currentTeam.blocked, teamId: currentTeam.teamId, teamCode: currentTeam.teamCode, teamImage: currentTeam.teamImage)
        
        TeamController.shared.editTeam(oldTeam: currentTeam, team: updatedTeam)
        
        teamNameLabel.text = updatedTeam.name
        self.updateForEdit()
    }
}
