//
//  SearchLocationViewController.swift
//  TeamyApp
//
//  Created by Ethan Scott on 6/25/21.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

protocol SaveToEventDelegate: AnyObject {
    func saveLocationInfo(placemark: MKPlacemark)
}

class SearchViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupSearchTable()
    }
    
    weak var delegate: SaveToEventDelegate?
    var resultSearchController: UISearchController?
    var locationManager = CLLocationManager()
    var selectedPin: MKPlacemark?
    
    //MARK: - Actions
    @IBAction func saveLocationButtonTapped(_ sender: Any) {
        guard let placemark = selectedPin else {return}
        delegate?.saveLocationInfo(placemark: placemark)
        
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Functions
    func setupSearchTable() {
        let locationSearchTable = storyboard?.instantiateViewController(identifier: "SearchTableViewController") as? SearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search for a location"
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.resultSearchController?.searchBar.becomeFirstResponder()
        }
        definesPresentationContext = true
        
        locationSearchTable?.mapView = mapView
        locationSearchTable?.handleMapSearchDelegate = self
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension SearchViewController: CLLocationManagerDelegate, UITableViewDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
    
}

extension SearchViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        
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
