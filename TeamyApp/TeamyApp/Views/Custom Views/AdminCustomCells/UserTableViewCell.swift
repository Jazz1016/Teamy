//
//  UserTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 7/5/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var UserNameLabel: UILabel!
    
    // MARK: - Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    var access: String? {
        didSet {
            accessLabel.text = access
        }
    }
    
    
    
    
    // MARK: - Functions
    func updateViews() {
        guard let user = user else {return}
        UserNameLabel.text = "\(user.firstName) \(user.lastName)"
    }
}//End of class
