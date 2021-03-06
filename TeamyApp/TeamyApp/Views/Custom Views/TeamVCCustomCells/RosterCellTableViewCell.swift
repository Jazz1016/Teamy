//
//  RosterCellTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 6/28/21.
//

import UIKit

class RosterCellTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var rosterLabel: UILabel!
    @IBOutlet weak var teamColorView: UIView!
    
    // MARK: - Properties
    var num: Int? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Functions
    func updateViews(){
        guard let num = num,
              let team = EventController.shared.team else {return}
        
        teamColorView.backgroundColor = UIColor.init(hexString: team.teamColor)
        teamColorView.layer.cornerRadius = 5
        if num == 1 {
            rosterLabel.text = "\(num) Player"
        } else {
            rosterLabel.text = "\(num) Players"
        }
        
    }
}//End of class
