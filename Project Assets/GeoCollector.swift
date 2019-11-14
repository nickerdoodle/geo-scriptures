//
//  GeoCollector.swift
//  Project 3 Version 1
//
//  Created by Nick Mahe on 11/12/19.
//  Copyright © 2019 Nick Mahe. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class GeoCollector: GeoPlaceCollector{
    
    var geoCodedPlaces: [GeoPlace]
    
    func setGeocodedPlaces(_ places: [GeoPlace]?) {
        if let geoPlaces = places{
            for place in geoPlaces{
                geoCodedPlaces.append(place)
            }
        }
    }
    
    private init(){
        self.geoCodedPlaces = [GeoPlace]()
    }
    
    static var shared = GeoCollector()
    
}
