//
//  EventController.swift
//  TeamyApp
//
//  Created by Ethan Scott on 6/23/21.
//

import Foundation
import FirebaseFirestore

class EventController {
    
    static let shared = EventController()
    
    var events: [Event] = []
    
    let database = Firestore.firestore()
    
    func createEvent(event: Event, team: Team) {
        let eventToAdd: Event = event
        
        let eventReference = database.collection("teams").document(team.teamId).collection("events").document(eventToAdd.eventID)
        eventReference.setData([
            "name" : eventToAdd.name,
            "date" : eventToAdd.date ?? Date(),
            "locationAddress" : eventToAdd.locationAddress,
            "locationName" : eventToAdd.locationName,
            "notes" : eventToAdd.notes,
            "eventID" : eventToAdd.eventID
        ])
        events.append(eventToAdd)
    }
    
    func fetchEvents(completion: @escaping (Bool) -> Void) {
        database.collection("events").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(false)
            }
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    let eventData = doc.data()
                    guard let name = eventData["name"] as? String,
                          let date = eventData["date"] as? Date,
                          let locationName = eventData["locationName"] as? String,
                          let locationAddress = eventData["locationAddress"] as? String,
                          let notes = eventData["notes"] as? String,
                          let eventID = eventData["eventID"] as? String else {return}
                    
                    let event = Event(date: date, name: name, locationAddress: locationAddress, locationName: locationName, notes: notes, eventID: eventID)
                    self.events.append(event)
                }
                completion(true)
            }
        }
    }
    
}
