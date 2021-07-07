//
//  EventTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var teamColorView: UIView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var teamColorAccentView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var index: Int? {
        didSet {
            guard let team = EventController.shared.team else {return}
            teamColorView.backgroundColor = UIColor.init(hexString: team.teamColor)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
