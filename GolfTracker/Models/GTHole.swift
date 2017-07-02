//
//  GTHole.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-01-30.
//  Copyright © 2017 markhall. All rights reserved.
//

import UIKit
import SwiftyJSON

class GTHoleYardage: NSObject {
    var distance: Int?
    var name: String?
    
    init(distance: Int?, name: String?) {
        self.distance = distance;
        self.name = name;
    }
    
    func toJSON() -> [String: Any?] {
        return [
            "distance":distance,
            "name":name
        ]
    }
    
    override var description: String {
        get{
            return "\(name ?? "N/A") \t\t\(distance ?? -1)yrds"
        }
    }
    
}

class GTHole: NSObject {
    
    var yardages = [GTHoleYardage]()
    var par: Int?
    var number: Int?
    
    override init() {

    }
    
    init(number: Int) {
        self.number = number
    }
    
    init(withJson json:JSON){
        
    }
    
    func toJSON() -> [String:Any?] {
        var networkYards = Array<[String:Any?]>()
        for yard in yardages {
            networkYards.append(yard.toJSON())
        }
        return [
            "yardages":networkYards,
            "par":par,
            "number":number
        ]
    }
    
    override var description: String {
        get{
            return "\n\(number ?? -1)==> \tPar:\(par ?? -1), \t\tTees:\(yardages)"
        }
    }

}

//extension GTHole {
//    
//    func didHaveGIR() -> Bool {
//        if let score = score, let par = par, let numberOfPutts = numberOfPutts{
//            return score <= par && numberOfPutts <= 2
//        }
//        return false
//    }
//    
//    func didGetUpAndDown() -> Bool {
//        if let score = score, let par = par, let numberOfPutts = numberOfPutts{
//            return score <= par && numberOfPutts == 1
//        }
//        return false
//    }
//    
//}
