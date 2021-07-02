//
//  TeamNameTableViewCell.swift
//  TeamyApp
//
//  Created by anthony byrd on 6/29/21.
//

import UIKit

class TeamNameTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var teamNameLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    //MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        
        teamName()
    }
    
    //MARK: - Properties
    static let identifier = "TeamNameTableViewCell"
    
    //MARK: - Methods
    func teamName() {
        guard let team = EventController.shared.team else { return }
        teamNameLabel.text = team.name
    }
}
