//
//  CreateEventViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import UIKit
import MapKit
import Firebase

class CreateEventViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventNotesTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var eventLocationNameLabel: UILabel!
    @IBOutlet weak var addLocationButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        lookPretty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideLabels()
        
        if eventAddressLabel.text != "Event Address" {
            addLocationButton.setTitle("Change Location", for: .normal)
//            eventLocationNameLabel.isHidden = false
        }
    }
    
    //MARK: - Actions
    @IBAction func saveEventButtonTapped(_ sender: Any) {
        guard let eventName = eventNameTextField.text, !eventName.isEmpty,
              let eventAddress = eventAddressLabel.text,
              let eventLocationName = eventLocationNameLabel.text,
              let eventNotes = eventNotesTextView.text else {return}
        
        let date = Timestamp(date: datePicker.date)
        
        let event = Event(date: date, name: eventName, locationAddress: eventAddress, locationName: eventLocationName, notes: eventNotes)
     
        guard let team = EventController.shared.team else {return}
        EventController.shared.createEvent(event: event, teamID: team.teamId)
        print("Successfully saved event")
        
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Functions
    func hideLabels() {
        eventAddressLabel.isHidden = true
        
        if eventLocationNameLabel.text == "Event Location Name" {
            eventLocationNameLabel.isHidden = true
        }
    }
    
    func lookPretty() {
        eventNotesTextView.layer.borderWidth = 1
        eventNotesTextView.layer.borderColor = CGColor(gray: 0, alpha: 0.2)
        eventNotesTextView.layer.cornerRadius = 10
        mapView.layer.cornerRadius = 10
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocationFinder" {
            guard let destinationVC = segue.destination as? SearchViewController else {return}
            destinationVC.delegate = self
        }
    }
    
    
    
}
extension CreateEventViewController: SaveToEventDelegate {
    
    func saveLocationInfo(placemark: MKPlacemark) {
        eventLocationNameLabel.text = placemark.name
        eventAddressLabel.text = placemark.title
        
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
           let state = placemark.administrativeArea {
            annotation.subtitle = "\(city), \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
}
