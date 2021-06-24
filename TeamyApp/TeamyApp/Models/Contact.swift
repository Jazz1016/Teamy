//
//  Contact.swift
//  TeamyApp
//
//  Created by James Lea on 6/24/21.
//

import Foundation

class Contact {
    let contactName: String
    let contactType: String
    let contactInfo: String
    let contactId: String
    init(contactName: String, contactType: String, contactInfo: String, contactId: String = UUID().uuidString){
        self.contactName = contactName
        self.contactType = contactType
        self.contactInfo = contactInfo
        self.contactId = contactId
    }
}
