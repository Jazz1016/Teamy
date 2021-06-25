//
//  AnnouncementController.swift
//  TeamyApp
//
//  Created by James Lea on 6/24/21.
//

import Foundation
import Firebase

class AnnouncementController {
    let shared = AnnouncementController()
    
    var announcements: [Announcement] = []
    
    let db = Firestore.firestore()
    
    // MARK: - CRUD
    func createAnnouncement(announcement: Announcement, teamId: String){
        db.collection("teams").document(teamId).collection("announcements").document(announcement.announcementId).setData([
            "title" : announcement.title,
            "details" : announcement.details,
            "announcementId" : announcement.announcementId
        ])
        announcements.append(announcement)
    }
    
    func fetchAnnouncements(teamId: String){
        db.collection("teams").document(teamId).collection("announcements").addSnapshotListener { snap, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return
            }
            if let snap = snap {
                self.announcements = []
                for doc in snap.documents {
                    let announcementData = doc.data()
                    guard let title = announcementData["title"] as? String,
                          let details = announcementData["details"] as? String,
                          let announcementId = announcementData["announcementId"] as? String else {return}
                    
                    let announcement = Announcement(title: title, details: details, announcementId: announcementId)
                    
                    self.announcements.append(announcement)
                }
            }
        }
    }
    
    func deleteAnnouncement(announcement: Announcement, teamId: String){
        guard let index = announcements.firstIndex(of: announcement) else {return}
        
        announcements.remove(at: index)

        db.collection("teams").document(teamId).collection("announcements").document(announcement.announcementId).delete() { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Announcement successfully removed")
            }
        }
    }
    
}
