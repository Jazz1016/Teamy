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
    var team: Team?
    var isAdmin: Bool = false
    
    let database = Firestore.firestore()
    
    func createEvent(event: Event, teamID: String) {
        let eventToAdd: Event = event
        guard let teamID = team?.teamId else {return}
      
        let eventReference = database.collection("teams").document(teamID).collection("events").document(eventToAdd.eventID)
        eventReference.setData([
            "name" : eventToAdd.name,
            "date" : eventToAdd.date,
            "locationAddress" : eventToAdd.locationAddress,
            "locationName" : eventToAdd.locationName,
            "notes" : eventToAdd.notes,
            "eventID" : eventToAdd.eventID
        ])
        events.append(eventToAdd)
    }
    
    func fetchEvents(teamID: String, completion: @escaping (Bool) -> Void) {
        database.collection("teams").document(teamID).collection("events").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(false)
            }
            if let snapshot = snapshot {
                self.events = []
                for doc in snapshot.documents {
                    let eventData = doc.data()
                    guard let name = eventData["name"] as? String,
                          let date = eventData["date"] as? Timestamp,
                          let locationName = eventData["locationName"] as? String,
                          let locationAddress = eventData["locationAddress"] as? String,
                          let notes = eventData["notes"] as? String,
                          let eventID = eventData["eventID"] as? String
                    else {return}
                    
                    let event = Event(date: date, name: name, locationAddress: locationAddress, locationName: locationName, notes: notes, eventID: eventID)
                    
                    self.events.append(event)
                    self.events.sort(by: { $0.date.dateValue() < $1.date.dateValue() })
                }
                completion(true)
            }
        }
    }
    
    func deleteEvent(with event: Event, teamID: String) {
        guard let teamID = team?.teamId else {return}
        
        guard let index = events.firstIndex(of: event) else { return }
        events.remove(at: index)
        database.collection("teams").document(teamID).collection("events").document(event.eventID).delete() { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Event successfully removed!")
                print(self.events.count)
            }
        }
    }
    
}
