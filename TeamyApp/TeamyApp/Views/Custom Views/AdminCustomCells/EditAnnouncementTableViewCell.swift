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
    
    func updateViews() {
        guard let announcement = announcement else {return}
        announcementLabel.text = announcement.title
        announcementTextField.text = announcement.title
        announcementDetailTextView.text = announcement.details
    }
    
    func updateAnnouncement() {
        guard let title = announcementTextField.text, !title.isEmpty,
              let details = announcementDetailTextView.text, !details.isEmpty,
              let team = team,
              let id = announcement?.announcementId else {return}
        let announcement = Announcement(title: title, details: details, announcementId: id)
        AnnouncementController.shared.updateAnnouncement(announcement: announcement, teamId: team.teamId)
        print(announcement.title)
        updateViews()
    }
    
    func isEditable() {
        if announcementDetailTextView.text == "There are no announcements at this time" {
            announcementTextField.isHidden = false
            announcementLabel.isHidden = true
            announcementDetailTextView.isEditable = true
            saveAnnouncementButton.isHidden = false
            announcementTextField.text = ""
            announcementDetailTextView.text = ""
        } else if announcementDetailTextView.text == "" {
            announcementTextField.isHidden = false
            announcementLabel.isHidden = true
            announcementDetailTextView.isEditable = true
            saveAnnouncementButton.isHidden = false
        } else {
            announcementTextField.isHidden = true
            announcementLabel.isHidden = false
            announcementDetailTextView.isEditable = false
            saveAnnouncementButton.isHidden = true
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
