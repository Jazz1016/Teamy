//
//  LeagueDetailsTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 7/2/21.
//

import UIKit

class LeagueDetailsTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var leagueDetailsLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    
    // MARK: - Properties
    var index: Int? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Functions
    func updateViews(){
        guard let team = EventController.shared.team else {return}
        leagueNameLabel.text = team.teamDesc.leagueName
        leagueDetailsLabel.text = team.teamDesc.detail
    }
}//End of class
