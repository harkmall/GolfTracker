//
//  GTCourse.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-01-30.
//  Copyright © 2017 markhall. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

class GTCourse: NSObject {
    
    var name: String?
    var tees: [GTTee]?
    var holes: [GTHole]?
    var location: CLLocationCoordinate2D?
    
    override init() {
        
    }
    
    convenience init(withJson json:JSON){
        let name = json["name"].string
        var tees = Array<GTTee>()
        let teesArray = json["tees"].array
        for teeJSON in teesArray! {
            tees.append(GTTee.init(withJson: teeJSON))
        }
        var holes = Array<GTHole>()
        let holesArray = json["holes"].array
        for holeJSON in holesArray! {
            holes.append(GTHole.init(withJson: holeJSON))
        }
        
        let location = CLLocationCoordinate2D(latitude: json["location"]["long"].double!, longitude: json["location"]["lat"].double!)
        
        self.init(withName: name, tees: tees, holes: holes, location: location)
    }
    
    init(withName name:String?, tees:[GTTee], holes:[GTHole], location: CLLocationCoordinate2D) {
        self.name = name
        self.tees = tees
        self.holes = holes
        self.location = location
    }

}
