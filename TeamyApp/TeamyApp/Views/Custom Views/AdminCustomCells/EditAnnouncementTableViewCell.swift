//
//  EditAnnouncementTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 7/5/21.
//

import UIKit

class EditAnnouncementTableViewCell: UITableViewCell, UITextViewDelegate {
    // MARK: - Outlets
    @IBOutlet weak var announcementTextField: UITextField!
    @IBOutlet weak var announcementDetailTextView: UITextView!
    @IBOutlet weak var saveAnnouncementButton: UIButton!
    @IBOutlet weak var announcementLabel: UILabel!
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        announcementDetailTextView.delegate = self
        announcementTextField.isHidden = true
        announcementDetailTextView.isEditable = false
        saveAnnouncementButton.isHidden = true
        addNotesTextViewBorder()
    }
    @IBAction func saveAnnouncementButtonTapped(_ sender: Any) {
        
    }
    
    var textChanged: ((String) -> Void)?
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
    }
    
    
    func updateForEdit() {
        announcementLabel.isHidden.toggle()
        announcementTextField.isHidden.toggle()
        announcementDetailTextView.isEditable.toggle()
        saveAnnouncementButton.isHidden.toggle()
    }
    
    func addNotesTextViewBorder() {
        announcementDetailTextView.layer.borderWidth = 1
        announcementDetailTextView.layer.borderColor = CGColor(gray: 0, alpha: 0.2)
        announcementDetailTextView.layer.cornerRadius = 10
    }
    
    func updateAnnouncement() {
        
    }
    
}
