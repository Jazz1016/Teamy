//
//  EventDetailViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/28/21.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventNotesTextView: UITextView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventLocationNameLabel: UILabel!
    @IBOutlet weak var editEventButton: UIBarButtonItem!
    @IBOutlet weak var openInMapsButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        openInMapsButton.layer.cornerRadius = 10
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    var event: Event?
    
    @IBAction func editEventButtonTapped(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "createEventVC") as? CreateEventViewController else {return}
        guard let event = event else {return}
        let nav = UINavigationController.init(rootViewController: vc)
        vc.event = event
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
  
    }
    
    @IBAction func openInMapsButtonTapped(_ sender: Any) {
        guard let address = eventAddressLabel.text else {return}
        
        EventController.shared.getCoordinate(addressString: address) { coordinates, error in
            if error == nil {
                let placemark = MKPlacemark(coordinate: coordinates)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = address
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            }
        }
        
    }
    
    func updateViews() {
        guard let event = event else {return}
        navigationController?.navigationBar.topItem?.title = "\(event.name)"
        eventNameLabel.text = event.name
        eventAddressLabel.text = event.locationAddress
        eventLocationNameLabel.text = event.locationName
        eventNotesTextView.text = event.notes
        eventDateLabel.text = event.date.dateValue().formatToFullString()
        displayOnMapView()
        addNotesTextViewBorder()
        showEditButton()
    }
    
    func displayOnMapView() {
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
    
    func addNotesTextViewBorder() {
        eventNotesTextView.layer.borderWidth = 1
        eventNotesTextView.layer.borderColor = CGColor(gray: 0, alpha: 0.2)
        eventNotesTextView.layer.cornerRadius = 10
        mapView.layer.cornerRadius = 10
    }
    
    func showEditButton() {
        if EventController.shared.isAdmin == true {
            editEventButton.isEnabled = true
        } else {
            editEventButton.isEnabled = false
            editEventButton.tintColor = UIColor.clear
        }
    }

}

extension EventDetailViewController: UpdateEventDetailDelegate {
    func updateEventView() {
        updateViews()
    }
}

extension EventDetailViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(EventDetailViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
