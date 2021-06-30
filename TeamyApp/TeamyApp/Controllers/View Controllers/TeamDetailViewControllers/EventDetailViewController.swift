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
    @IBOutlet weak var eventNotesLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventLocationNameLabel: UILabel!
    @IBOutlet weak var editEventButton: UIBarButtonItem!
    @IBOutlet weak var goingButton: UIButton!
    @IBOutlet weak var maybeButton: UIButton!
    @IBOutlet weak var notGoingButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    @IBAction func editEventButtonTapped(_ sender: Any) {
        
        
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
        eventNameLabel.text = event.name
        eventAddressLabel.text = event.locationAddress
        eventLocationNameLabel.text = event.locationName
        eventNotesLabel.text = event.notes
        eventDateLabel.text = event.date.dateValue().formatToString()
    }
    
    func selectAttendenceStatus() {
        
        if goingButton.isSelected {
            
        } else if maybeButton.isSelected {
            
        } else if notGoingButton.isSelected {
            
        }
        
    }
}
