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
    @IBOutlet weak var contactTypeTextfield: UITextField!
    @IBOutlet weak var contactInfoTextfield: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    //MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Properties
    var contactIndex: Int? {
        didSet {
            initializeViews()
        }
    }
    
    var contact: Contact? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        updateContact()
    }
    
    
    // MARK: - Methods
    func updateViews() {
        guard let contact = contact else { return }
        contactNameLabel.text = contact.contactName
        contactTypeLabel.text = contact.contactType
        contactInfoLabel.text = contact.contactInfo
        contactNameTextfield.text = contact.contactName
        contactTypeTextfield.text = contact.contactType
        contactInfoTextfield.text = contact.contactInfo
    }
    
    func initializeViews() {
        contactNameTextfield.isHidden = true
        contactTypeTextfield.isHidden = true
        contactInfoTextfield.isHidden = true
        saveButton.isHidden = true
    }
    
    func updateForEdit() {
        contactNameLabel.isHidden.toggle()
        contactTypeLabel.isHidden.toggle()
        contactInfoLabel.isHidden.toggle()
        contactNameTextfield.isHidden.toggle()
        contactTypeTextfield.isHidden.toggle()
        contactInfoTextfield.isHidden.toggle()
        saveButton.isHidden.toggle()
    }
    
    func updateContact() {
        guard let contact = contact else { return }
        
        let contactUpdated = Contact(contactName: contactNameTextfield.text ?? "", contactType: contactTypeTextfield.text ?? "", contactInfo: contactInfoTextfield.text ?? "", contactId: contact.contactId)
        
        ContactController.shared.updateContact(oldContact: contact, contact: contactUpdated, teamID: EventController.shared.team!.teamId) { bool in
        }
        
        contactNameLabel.text = contactUpdated.contactName
        contactTypeLabel.text = contactUpdated.contactType
        contactInfoLabel.text = contactUpdated.contactInfo
        self.updateForEdit()
    }
}//End of class
