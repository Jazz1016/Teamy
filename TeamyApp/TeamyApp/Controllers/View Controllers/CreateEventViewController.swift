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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Actions
    @IBAction func addLocationButtonTapped(_ sender: Any) {
        
    }
    
    
    
}
