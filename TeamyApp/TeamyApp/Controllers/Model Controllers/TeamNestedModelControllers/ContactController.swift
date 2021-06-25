//
//  ContactController.swift
//  TeamyApp
//
//  Created by James Lea on 6/24/21.
//

import Foundation
import Firebase

class ContactController {
    let shared = ContactController()
    
    var contacts: [Contact] = []
    
    let db = Firestore.firestore()
    
    // MARK: - Contact CRUD
    
    func createContact(contact: Contact, teamId: String){
        db.collection("teams").document(teamId).collection("contacts").document(contact.contactId).setData([
            "contactName" : contact.contactName,
            "contactType" : contact.contactType,
            "contactInfo" : contact.contactInfo,
            "contactId" : contact.contactId
        ])
        contacts.append(contact)
    }
    
    func fetchContacts(teamId: String){
        db.collection("teams").document(teamId).collection("contacts").addSnapshotListener { snap, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return
            }
            
            if let snap = snap {
                self.contacts = []
                for doc in snap.documents {
                    let contactData = doc.data()
                    guard let contactName = contactData["contactName"] as? String,
                          let contactType = contactData["contactType"] as? String,
                          let contactInfo = contactData["contactInfo"] as? String,
                          let contactId = contactData["contactId"] as? String else {return}
                    
                    let contact = Contact(contactName: contactName, contactType: contactType, contactInfo: contactInfo, contactId: contactId)
                    
                    self.contacts.append(contact)
                }
            }
        }
    }
    
    func deleteContact(contact: Contact, teamId: String){
        guard let index = contacts.firstIndex(of: contact) else {return}
        
        db.collection("teams").document(teamId).collection("contacts").document(contact.contactId).delete() {
            error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Contact successfully removed")
            }
        }
    }
    
}//End of class
