//
//  PlayerTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 6/29/21.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerRole: UILabel!
    @IBOutlet weak var jerseyNumber: UILabel!
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
    
    // MARK: - Actions
    @IBOutlet weak var saveEditButtonTapped: UIButton!
    
    // MARK: - Functions
    func updateViews(){
        
    }
    
}//End of class
