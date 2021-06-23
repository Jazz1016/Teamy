//
//  TeamTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var teamNameTableView: UILabel!
    
    // MARK: - Properties
    var team: Team? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews(){
        guard let team = team else {return}
        
        teamNameTableView.text = team.name
    }
    
}
