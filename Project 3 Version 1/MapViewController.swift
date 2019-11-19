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
    
    var detailItem: NSDate?
    
    @IBOutlet weak var mapView: MKMapView!
    var annotations: [MapAnnotation] = [MapAnnotation]()
    static var textClicked = false
    
    @IBAction func resetMap(_ sender: UIBarButtonItem) {
        setMap()
        //Set title here
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            for place in GeoCollector.shared.geoCodedPlaces{
                if annotations.contains(MapAnnotation(title: place.placename, subtitle: "\(place.latitude), \(place.longitude)", latitude: place.viewLatitude!, longitude: place.viewLongitude!))
                {
                    
                }
                else{
                    annotations.append(MapAnnotation(title: place.placename, subtitle: "\(place.latitude), \(place.longitude)", latitude: place.viewLatitude!, longitude: place.viewLongitude!))
                }
                
            
            }
    
        mapView.addAnnotations(annotations)
        print("end annotations")
        for place in annotations{
            print(place.title!)
        }
        
        //mapView.setRegion(MKCoordinateRegion(, animated: )
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMap()
        
        
    }
    
    func setMap(){
        if !MapViewController.textClicked{
            mapView.showAnnotations(annotations, animated: true)
        }
        else{
            let place = GeoDatabase.shared.geoPlaceForId(Int(ScriptureViewController.scriptureId)!)
            if let geoPlace = place{
                mapView.setCenter(CLLocationCoordinate2D(latitude: geoPlace.latitude, longitude: geoPlace.longitude), animated: true)
                mapView.setCamera(MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: geoPlace.latitude, longitude: geoPlace.longitude), fromEyeCoordinate: CLLocationCoordinate2D(latitude: geoPlace.latitude, longitude: geoPlace.longitude), eyeAltitude: 1.4), animated: true)
            }
            MapViewController.textClicked = false
        }
    }

    
    
}
