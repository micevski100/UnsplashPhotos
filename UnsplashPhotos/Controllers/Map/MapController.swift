//
//  MapController.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 6.12.23.
//

import Foundation
import CoreLocation
import MapKit

class MapController: BaseController<MapView> {
    
    let manager = CLLocationManager()
    var lat: CLLocationDegrees? = nil
    var lon: CLLocationDegrees? = nil
    
    class func factoryController(lat: Double, lon: Double) -> ContentController<MapView> {
        let controller = MapController()
        controller.lat = lat
        controller.lon = lon
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    private func render(_ location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2D(latitude: self.lat ?? location.coordinate.latitude,
                                                longitude: self.lon ?? location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.contentView.mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        self.contentView.mapView.addAnnotation(pin)
    }
    
}

extension MapController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
}
