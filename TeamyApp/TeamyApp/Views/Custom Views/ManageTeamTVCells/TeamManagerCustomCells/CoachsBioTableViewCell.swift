//
//  CoachsBioTableViewCell.swift
//  TeamyApp
//
//  Created by anthony byrd on 6/29/21.
//

import UIKit

class CoachsBioTableViewCell: UITableViewCell {
    
    static let identifier = "CoachsBioTableViewCell"
    
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
