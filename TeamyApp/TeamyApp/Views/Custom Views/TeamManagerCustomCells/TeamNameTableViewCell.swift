//
//  TeamNameTableViewCell.swift
//  TeamyApp
//
//  Created by anthony byrd on 6/29/21.
//

import UIKit

class TeamNameTableViewCell: UITableViewCell {
    
    static let identifier = "TeamNameTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
