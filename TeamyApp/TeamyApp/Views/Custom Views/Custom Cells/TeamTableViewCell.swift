//
//  TeamTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    // MARK: - Outlets
    
    @IBOutlet weak var teamColorView: UIView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var coachNameLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    
    // MARK: - Properties
    var team: Team? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews(){
        guard let team = team else {return}
        
        teamColorView.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
        teamNameLabel.text = team.name
        leagueNameLabel.text = team.teamDesc.leagueName
        memberCountLabel.text = "\(team.members.count + team.admins.count) members"
    }
    
}
