//
//  Event.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import Foundation

class Event {
    
    var date: Date?
    var name: String
    var locationAddress: String
    var locationName: String
    var notes: String
    var eventID: String
    
    
    init(date: Date, name: String, locationAddress: String, locationName: String, notes: String, eventID: String = UUID().uuidString) {
        self.date = date
        self.name = name
        self.locationAddress = locationAddress
        self.locationName = locationName
        self.notes = notes
        self.eventID = eventID
    }
    
}
