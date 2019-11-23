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

    var selection: (Book, Int)?
    
    @IBOutlet weak var mapView: MKMapView!
    var annotations: [MapAnnotation] = [MapAnnotation]()
    static var textClicked = false
    private static var titleForMap: (Book, Int)?
    
    @IBAction func resetMap(_ sender: UIBarButtonItem) {
        setMap()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Grab the geoplaces and created pins for them
            for place in GeoCollector.shared.geoCodedPlaces{
                if annotations.contains(MapAnnotation(title: place.placename, subtitle: "\(place.latitude), \(place.longitude)", latitude: place.viewLatitude!, longitude: place.viewLongitude!))
                {
                    
                }
                else{
                    annotations.append(MapAnnotation(title: place.placename, subtitle: "\(place.latitude), \(place.longitude)", latitude: place.viewLatitude!, longitude: place.viewLongitude!))
                }
                
            
            }
    
        mapView.addAnnotations(annotations)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMap()
     
    }
  
    //Sets the title for the map's nav controller and sets the pins
    func setMap(){
        
        if !MapViewController.textClicked{
            mapView.showAnnotations(annotations, animated: true)
            MapViewController.titleForMap = selection
            if let mapTitle = MapViewController.titleForMap{
                //Need to account for one chapter and 0 chapter books
                if let numChapters = selection?.0.numChapters{
                    if numChapters > 1{
                        self.title = "\(mapTitle.0.backName) \(mapTitle.1)"
                    }
                        //books with one chapter
                    else{
                        self.title = "\(mapTitle.0.backName)"
                    }
                }
                    //books with no chapters
                else{
                    self.title = "\(mapTitle.0.backName)"
                }
                
                
            }
        }
            //for clicking a place in the text
        else{
            let place = GeoDatabase.shared.geoPlaceForId(Int(ScriptureViewController.scriptureId)!)
            if let geoPlace = place{
                mapView.setCenter(CLLocationCoordinate2D(latitude: geoPlace.latitude, longitude: geoPlace.longitude), animated: true)
                mapView.setCamera(MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: geoPlace.latitude, longitude: geoPlace.longitude), fromEyeCoordinate: CLLocationCoordinate2D(latitude: geoPlace.latitude, longitude: geoPlace.longitude), eyeAltitude: geoPlace.viewAltitude!), animated: true)
                self.title = geoPlace.placename
            }
            MapViewController.textClicked = false
        }
        
        self.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
    }

    
    
}
