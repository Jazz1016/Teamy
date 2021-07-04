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
        guard let num = num else {return}
        rosterLabel.text = "\(num) Players"
    }
}//End of class
