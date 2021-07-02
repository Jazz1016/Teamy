//
//  CoachsBioTableViewCell.swift
//  TeamyApp
//
//  Created by anthony byrd on 6/29/21.
//

import UIKit

class CoachsBioTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var coachBioLabel: UILabel!
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        coachBio()
    }
    
    //MARK: - Properties
    static let identifier = "CoachsBioTableViewCell"
    var user: User?
    
    //MARK: - Methods
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func coachBio() {
        if let user = user {
            coachBioLabel.text = user.lastName
        } else {
            coachBioLabel.text = "Coaches Bio"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
