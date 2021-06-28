//
//  SearchLocationTableViewController.swift
//  TeamyApp
//
//  Created by Ethan Scott on 6/25/21.
//

import UIKit
import MapKit

class SearchTableViewController: UITableViewController {
    
    //MARK: - Outlets
//    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    var resultSearchController: UISearchController? = nil
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    var handleMapSearchDelegate: HandleMapSearch?
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)

        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = selectedItem.title


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        
        dismiss(animated: true)
    }

} //End of class

extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text,
              let mapView = mapView else {return}
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
                guard let response = response else {
                    return
                }
                self.matchingItems = response.mapItems
                self.tableView.reloadData()
            }
    }
}
