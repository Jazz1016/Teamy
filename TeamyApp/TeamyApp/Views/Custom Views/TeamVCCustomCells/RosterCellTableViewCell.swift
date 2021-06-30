//
//  RosterCellTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 6/28/21.
//

import UIKit

class RosterCellTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var rosterCell: UILabel!
    
    // MARK: - Properties
    var num: Int? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Functions
    func updateViews(){
        guard let num = num else {return}
        rosterCell.text = "\(num) Players"
    }
}//End of class
