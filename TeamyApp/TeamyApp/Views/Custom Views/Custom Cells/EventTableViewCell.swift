//
//  EventTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
