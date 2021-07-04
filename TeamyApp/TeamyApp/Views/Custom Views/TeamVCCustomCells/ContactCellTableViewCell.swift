//
//  ContactCellTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 6/28/21.
//

import UIKit

class ContactCellTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var teamColorView: UIView!
    
    // MARK: - Properties
    var contact: Contact? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Functions
    func updateViews(){
        guard let contact = contact else {return}
        contactNameLabel.text = contact.contactName
    }
}//End of class
