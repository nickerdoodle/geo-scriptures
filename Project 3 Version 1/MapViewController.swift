//
//  MapViewController.swift
//  Project 3 Version 1
//
//  Created by Nick Mahe on 11/11/19.
//  Copyright © 2019 Nick Mahe. All rights reserved.
//

import UIKit
import WebKit
import MapKit

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mapView.setRegion(MKCoordinateRegion(, animated: )
        mapView.addAnnotation(MapAnnotation(title: "Test", subtitle: "Test", latitude: 40.0, longitude: -111.0))
    }
    
    
}
