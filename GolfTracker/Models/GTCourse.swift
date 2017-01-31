//
//  GTCourse.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-01-30.
//  Copyright © 2017 markhall. All rights reserved.
//

/*
 courseSchema = new db.Schema({
     name: String,
     tees: [{
         name: String,
         slope: Number,
         rating: Number
     }],
     holes: [{
         hole: Number,
         yards: [{
             name: String,
             distance: String
         }],
         par: Number
     }],
     location: {
         lat: Number,
         long: Number
     },
 })
 
 */

import UIKit
import SwiftyJSON

struct GTCourseLocation {
    var latitude: Double
    var longitude: Double
    
    init(longitudeValue: Double?, latitudeValue: Double?){
        longitude = longitudeValue!
        latitude = latitudeValue!
    }
}

class GTCourse: NSObject {
    
    var name: String?
    var tees: Array<GTTee>?
    var holes: Array<GTHole>?
    var location: GTCourseLocation?
    
    init(withJson json:JSON){
        name = json["name"].string
        tees = Array<GTTee>()
        let teesArray = json["tees"].array
        for teeJSON in teesArray! {
            tees?.append(GTTee.init(withJson: teeJSON))
        }
        holes = Array<GTHole>()
        let holesArray = json["holes"].array
        for holeJSON in holesArray! {
            holes?.append(GTHole.init(withJson: holeJSON))
        }
        location = GTCourseLocation.init(longitudeValue: json["location"]["long"].double, latitudeValue: json["location"]["lat"].double)
        
        
    }

}
