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
    
    // MARK: - Properties
    var player: Player? {
        didSet {
            updateViews()
        }
    }
    var playerIndex: Int?
    
    // MARK: - Actions
    @IBAction func saveEditButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Functions
    func updateViews(){
        guard let player = player else {return}
        
    }
    
}//End of class
