//
//  ManageTeamTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 6/28/21.
//

import UIKit

class ManageTeamTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var manageTeamButton: UIButton!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var index: Int? {
        didSet {
            roundButton()
        }
    }
    
    func roundButton(){
        manageTeamButton.layer.cornerRadius = 10
    }
    
}
