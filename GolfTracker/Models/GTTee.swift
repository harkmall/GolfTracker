//
//  GTTee.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-01-30.
//  Copyright © 2017 markhall. All rights reserved.
//

import UIKit
import SwiftyJSON

class GTTee: NSObject {
    
    var name: String?
    var distance: Int?
    var slope: Int?
    var rating: Int?
    
    override init() {
        
    }
    
    init(withJson json:JSON){
        
    }
    
    func toJSON() -> [String: Any?] {
        return [
            "name":name,
            "distance":distance,
            "slope":slope,
            "rating":rating
        ]
    }
    
    override var description: String {
        get {
            return "\(name ?? "no name") \(distance ?? -1) \(slope ?? -1) \(rating ?? -1)"
        }
    }

}
