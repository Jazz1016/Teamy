//
//  TeamEventsTableViewCell.swift
//  TeamyApp
//
//  Created by anthony byrd on 6/29/21.
//

import UIKit

class TeamEventsTableViewCell: UITableViewCell {
    
    static let identifier = "TeamEventsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
