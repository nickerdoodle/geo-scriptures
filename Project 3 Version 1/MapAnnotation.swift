//
//  MapAnnotation.swift
//  Project 3 Version 1
//
//  Created by Nick Mahe on 11/11/19.
//  Copyright © 2019 Nick Mahe. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation{
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, latitude: Double, longitude: Double){
        self.title = title
        self.subtitle = subtitle
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
}
