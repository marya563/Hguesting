//
//  MapViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 1/5/2023.
//

import UIKit
import MapKit

class MapViewController: UIViewController {


    @IBOutlet var mapView: MKMapView!
    
    var address: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform a search for the address
        if let address = address {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = address
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                if let mapItems = response?.mapItems {
                    let placemark = mapItems[0].placemark
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = placemark.coordinate
                    annotation.title = placemark.name
                    annotation.subtitle = placemark.title
                    self.mapView.addAnnotation(annotation)
                    self.mapView.setRegion(MKCoordinateRegion(center: placemark.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
                }
            }
        }
    }
}
