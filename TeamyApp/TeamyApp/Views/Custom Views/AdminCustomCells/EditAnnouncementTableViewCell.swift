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
//        announcementDetailTextView.delegate = self
    }
    
    @IBAction func saveAnnouncementButtonTapped(_ sender: Any) {
        announcementTextField.isHidden = true
        announcementLabel.isHidden = false
        announcementDetailTextView.isEditable = false
        saveAnnouncementButton.isHidden = true
        updateAnnouncement()
    }
    
   
    var announcement: Announcement? {
        didSet {
            updateViews()
            isEditable()
            addAnnouncementTextViewBorder()
        }
    }
    var team: Team?
//    var textChanged: ((String) -> Void)?
//
//    func textChanged(action: @escaping (String) -> Void) {
//        self.textChanged = action
//    }
//
//    func textViewDidChange(_ textView: UITextView) {
//        textChanged?(textView.text)
//    }
    
    func updateViews() {
        guard let announcement = announcement else {return}
        announcementLabel.text = announcement.title
        announcementTextField.text = announcement.title
        announcementDetailTextView.text = announcement.details
    }
    
    func updateAnnouncement() {
        guard let title = announcementTextField.text, !title.isEmpty,
              let details = announcementDetailTextView.text, !details.isEmpty,
              let team = team else {return}
        let announcement = Announcement(title: title, details: details)
        AnnouncementController.shared.updateAnnouncement(announcement: announcement, teamId: team.teamId)
        
    }
    
    func isEditable() {
        if announcementDetailTextView.text != "" {
            announcementTextField.isHidden = true
            announcementLabel.isHidden = false
            announcementDetailTextView.isEditable = false
            saveAnnouncementButton.isHidden = true
        } else {
            announcementTextField.isHidden = false
            announcementLabel.isHidden = true
            announcementDetailTextView.isEditable = true
            saveAnnouncementButton.isHidden = false
        }
    }
    
    func updateForEdit() {
        announcementLabel.isHidden.toggle()
        announcementTextField.isHidden.toggle()
        announcementDetailTextView.isEditable.toggle()
        saveAnnouncementButton.isHidden.toggle()
    }
    
    func addAnnouncementTextViewBorder() {
        announcementDetailTextView.layer.borderWidth = 1
        announcementDetailTextView.layer.borderColor = CGColor(gray: 0, alpha: 0.2)
        announcementDetailTextView.layer.cornerRadius = 10
    }
    
}
