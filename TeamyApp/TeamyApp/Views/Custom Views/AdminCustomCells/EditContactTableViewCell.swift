//
//  EditContactTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 7/5/21.
//

import UIKit

class EditContactTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactTypeLabel: UILabel!
    @IBOutlet weak var contactInfoLabel: UILabel!
    @IBOutlet weak var contactNameTextfield: UITextField!
    @IBOutlet weak var contactType: UITextField!
    @IBOutlet weak var contactInfo: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    //MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Properties
    var contact: Contact? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    
    // MARK: - Methods
    func updateViews() {
        guard let contact = contact else { return }
        contactNameLabel.text = contact.contactName
        contactType.text = contact.contactType
        contactInfo.text = contact.contactInfo
    }
    
}//End of class
