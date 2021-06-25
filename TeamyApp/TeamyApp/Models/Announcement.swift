//
//  Announcement.swift
//  TeamyApp
//
//  Created by James Lea on 6/24/21.
//

import Foundation

class Announcement {
    let title: String
    let details: String
    let announcementId: String
    init(title: String, details: String, announcementId: String = UUID().uuidString){
        self.title = title
        self.details = details
        self.announcementId = announcementId
    }
}
