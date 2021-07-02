//
//  TeamBioTableViewCell.swift
//  TeamyApp
//
//  Created by anthony byrd on 6/29/21.
//

import UIKit

class TeamBioTableViewCell: UITableViewCell {
    
    static let identifier = "TeamBioTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Properties
    
    
    //MARK: - <#Section Heading#>

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
