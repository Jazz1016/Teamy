//
//  AnnounceTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 6/28/21.
//

import UIKit

class AnnounceTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var announcementLabel: UILabel!
    @IBOutlet weak var announcementDetail: UILabel!
    
    // MARK: Properties
    var announcement: Announcement? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Functions
    func updateViews() {
        guard let announcement = announcement else {return}
        
        announcementLabel.text = announcement.title
        announcementDetail.text = announcement.details
    }
    
}//End of class
