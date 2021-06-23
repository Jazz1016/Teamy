//
//  CreateEventViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import UIKit
import MapKit

class CreateEventViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventNotesTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: - Actions
    @IBAction func addLocationButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func saveEventButtonTapped(_ sender: Any) {
        guard let eventName = eventNameTextField.text, !eventName.isEmpty,
              let eventAddress = eventAddressLabel.text, !eventAddress.isEmpty else {return}
        
        let event = Event(date: datePicker.date, name: eventName, locationAddress: eventAddress, locationName: "Event Location", notes: eventNotesTextView.text)
     
        guard let team = EventController.shared.team else {return}
        EventController.shared.createEvent(event: event, teamID: team.teamId)
    }
    
    
}
