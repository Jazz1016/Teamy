//
//  EditTeamColorTableViewCell.swift
//  TeamyApp
//
//  Created by anthony byrd on 7/2/21.
//

import UIKit

class EditTeamColorTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var editTeamColorButton: UIButton!
    @IBOutlet weak var teamAccentColor: UIView!
    
    //MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        editTeamColorButton.layer.cornerRadius = 20
        updatedColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - Properties

    //MARK: - Actions
    @IBAction func editTeamColorButtonTapped(_ sender: Any) {
        
    }
    
    //MARK: - Methods
    func updatedColor() {
        guard let team = EventController.shared.team else { return }
        editTeamColorButton.backgroundColor = UIColor.init(hexString: team.teamColor)
        teamAccentColor.backgroundColor = UIColor.init(hexString: team.teamColor)
        teamAccentColor.layer.cornerRadius = 5
    }
}
