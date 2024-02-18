//
//  MapView.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 6.12.23.
//

import Foundation
import MapKit

class MapView: ContentView {
    
    var mapView: MKMapView!
    
    override func setupViews() {
        super.setupViews()
        
        mapView = MKMapView()
        self.addSubview(mapView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
