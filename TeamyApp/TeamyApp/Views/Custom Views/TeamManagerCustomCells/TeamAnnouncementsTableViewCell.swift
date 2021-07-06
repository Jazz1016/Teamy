//
//  TeamAnnouncementsTableViewCell.swift
//  TeamyApp
//
//  Created by anthony byrd on 6/29/21.
//

import UIKit

class TeamAnnouncementsTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var teamAccentColorView: UIView!
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        teamAccentColor()
    }
    
    //MARK: - Properties
    static let identifier = "TeamAnnouncementsTableViewCell"
    
    //MARK: - Methods
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func teamAccentColor() {
        guard let accentColor = EventController.shared.team else { return }
        teamAccentColorView.backgroundColor = UIColor.init(hexString: accentColor.teamColor)
        teamAccentColorView.layer.cornerRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
