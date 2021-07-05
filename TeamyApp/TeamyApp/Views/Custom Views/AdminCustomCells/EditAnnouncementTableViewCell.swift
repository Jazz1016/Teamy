//
//  EditAnnouncementTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 7/5/21.
//

import UIKit

class EditAnnouncementTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var announcementTextField: UITextField!
    @IBOutlet weak var announcementDetailTextView: UITextView!
    @IBOutlet weak var saveAnnouncementButton: UIButton!
    @IBOutlet weak var announcementLabel: UILabel!
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
