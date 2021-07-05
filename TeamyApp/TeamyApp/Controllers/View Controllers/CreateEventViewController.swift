//
//  CreateEventViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/22/21.
//

import UIKit
import MapKit
import Firebase

protocol UpdateEventDetailDelegate: AnyObject {
    func updateEventView()
}

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
        updateViews()
        addNotesTextViewBorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideLabels()
        
        if eventAddressLabel.text != "Event Address" {
            addLocationButton.setTitle("Change Location", for: .normal)
        }
    }
    
    weak var delegate: UpdateEventDetailDelegate?
    var event: Event?
    
    //MARK: - Actions
    @IBAction func saveEventButtonTapped(_ sender: Any) {
        guard let eventName = eventNameTextField.text, !eventName.isEmpty,
              let eventAddress = eventAddressLabel.text,
              let eventLocationName = eventLocationNameLabel.text,
              let eventNotes = eventNotesTextView.text,
              let team = EventController.shared.team else {return}
        let date = Timestamp(date: datePicker.date)
        
        if let event = event {
            event.name = eventName
            event.locationAddress = eventAddress
            event.locationName = eventLocationName
            event.notes = eventNotes
            event.date = date
            
            EventController.shared.updateEvent(event: event, teamID: team.teamId)
            print("Successfully updated event")
            self.dismiss(animated: true, completion: nil)
            delegate?.updateEventView()
        } else {
            let event = Event(date: date, name: eventName, locationAddress: eventAddress, locationName: eventLocationName, notes: eventNotes)
            EventController.shared.createEvent(event: event, teamID: team.teamId)
            print("Successfully created event")
            navigationController?.popViewController(animated: true)
        }
    }
    
    func updateViews() {
        guard let event = event else {return}
        eventNameTextField.text = event.name
        eventAddressLabel.text = event.locationAddress
        eventNotesTextView.text = event.notes
        datePicker.date = event.date.dateValue()
        eventLocationNameLabel.text = event.locationName
        dropPin()
    }
    
    //MARK: - Functions
    func dropPin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let address = self.eventAddressLabel.text else {return}
            EventController.shared.getCoordinate(addressString: address) { coordinates, error in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
                self.mapView.removeAnnotations(self.mapView.annotations)
                let placemark = MKPlacemark(coordinate: coordinates)
                let annotation = MKPointAnnotation()
                annotation.coordinate = placemark.coordinate
                
                self.mapView.addAnnotation(annotation)
                let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func hideLabels() {
        eventAddressLabel.isHidden = true
        
        if eventLocationNameLabel.text == "Event Location Name" {
            eventLocationNameLabel.isHidden = true
        }
    }
    
    func addNotesTextViewBorder() {
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
