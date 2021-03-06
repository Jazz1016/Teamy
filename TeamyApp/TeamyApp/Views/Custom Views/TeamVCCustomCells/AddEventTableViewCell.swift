//
//  AddEventTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 7/2/21.
//

import UIKit

class AddEventTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var addEventButton: UIButton!
    
    var index: Int? {
        didSet {
            addEventButton.layer.cornerRadius = 10
        }
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
