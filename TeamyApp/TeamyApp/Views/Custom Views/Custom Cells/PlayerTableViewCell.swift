//
//  PlayerTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 6/29/21.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerRoleLabel: UILabel!
    @IBOutlet weak var jerseyNumberLabel: UILabel!
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var playerRoleTextField: UITextField!
    @IBOutlet weak var jerseyNumberTextField: UITextField!
    @IBOutlet weak var saveEditButton: UIButton!
    @IBOutlet weak var accentTeamColorView: UIView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    
    // MARK: - Properties
    
    var playerIndex: Int? {
        didSet {
            initializeViews()
        }
    }
    
    var player: Player? {
        didSet {
            updateViews()
            
            
        }
    }
    
    weak var delegate: AnyObject?
    
    // MARK: - Actions
    @IBAction func saveEditButtonTapped(_ sender: Any) {
        updatePlayer()
    }
    
    
    // MARK: - Functions
    func updateViews(){
        guard let player = player else {return}
        playerNameLabel.text = player.name
        playerRoleLabel.text = player.role
        jerseyNumberLabel.text = player.jerseyNumber
        playerNameTextField.text = player.name
        playerRoleTextField.text = player.role
        jerseyNumberTextField.text = player.jerseyNumber
    }
    
    func initializeViews(){
        playerNameTextField.isHidden = true
        playerRoleTextField.isHidden = true
        jerseyNumberTextField.isHidden = true
        saveEditButton.isHidden = true
        jerseyNumberTextField.keyboardType = UIKeyboardType.numberPad
        guard let team = EventController.shared.team else {return}
        accentTeamColorView.backgroundColor = UIColor.init(hexString: team.teamColor)
    }
    
    func updateForEdit(){
        playerNameLabel.isHidden.toggle()
        playerRoleLabel.isHidden.toggle()
        jerseyNumberLabel.isHidden.toggle()
        playerNameTextField.isHidden.toggle()
        playerRoleTextField.isHidden.toggle()
        jerseyNumberTextField.isHidden.toggle()
        saveEditButton.isHidden.toggle()
    }
    
    func updatePlayer(){
        guard let player = player else {return}
        
        let playerUpdated = Player(name: playerNameTextField.text ?? "", role: playerRoleTextField.text ?? "", jerseyNumber: jerseyNumberTextField.text ?? "", playerId: player.playerId)
        
        PlayerController.shared.updatePlayer(oldPlayer: player, player: playerUpdated, teamId: EventController.shared.team!.teamId, completion: { bool in
        })
        playerNameLabel.text = playerUpdated.name
        playerRoleLabel.text = playerUpdated.role
        jerseyNumberLabel.text = playerUpdated.jerseyNumber
        self.updateForEdit()
    }
    
}//End of class
