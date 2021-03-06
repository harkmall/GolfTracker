//
//  GTNetworkingManager.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-01-28.
//  Copyright © 2017 markhall. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class GTNetworkingManager: NSObject {
    
    static let sharedManager = GTNetworkingManager()
    
    let endpointClosure = { (target: GTEndpoints) -> Endpoint<GTEndpoints> in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        switch target{
        case .login, .signUp, .courseSearch, .saveCourse:
            return defaultEndpoint
        case .stats:
            return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "bearer \(UserDefaults.standard.value(forKey: GTUserToken)!)"])
        }
    }
    
    private var provider = MoyaProvider<GTEndpoints>()
    
    private override init() {
        provider = MoyaProvider<GTEndpoints>(endpointClosure: endpointClosure)
    }
    
    func signUp(username: String, password: String, completion:@escaping ((_ response: JSON)->Void)){
        provider.request(.signUp(username: username, password: password)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data:moyaResponse.data)
                completion(json)
                break
            case let .failure(error):
                print(error)
                break
            }
        }
    }
    
    func login(username: String, password: String, completion:@escaping ((_ response: JSON)->Void)){
        provider.request(.login(username: username, password: password)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data:moyaResponse.data)
                completion(json)
                break
            case let .failure(error):
                print(error)
                break
            }
        }
    }
    
    func getOverallStats(completion:@escaping ((_ response: JSON)->Void)){
        provider.request(.stats) { (result) in
            switch result {
            case let .success(moyaResponse):
                print(moyaResponse)
                let json = JSON(data:moyaResponse.data)
                completion(json)
                break
            case let .failure(error):
                print(error)
                break
            }
        }
    }
    
    func searchForCourse(name: String, completion:@escaping ((_ response: JSON)->Void)){
        provider.request(.courseSearch(searchString: name)) { (result) in
            switch result {
            case let .success(moyaResponse):
                print(moyaResponse)
                let json = JSON(data:moyaResponse.data)
                completion(json)
                break
            case let .failure(error):
                print(error)
                break
            }
        }
    }
    
    func saveCourse(course: GTCourse, completion:@escaping ((_ response: JSON)->Void)){
        
        if let courseTees = course.tees, let courseHoles = course.holes, let courseLocation  = course.location, let name = course.name {
            var tees = [[String:Any?]]()
            for tee in courseTees {
                tees.append(tee.toJSON())
            }
            
            var holes = [[String:Any?]]()
            for hole in courseHoles {
                holes.append(hole.toJSON())
            }
            provider.request(.saveCourse(name: name, tees: tees, holes: holes, location: ["longitude":courseLocation.longitude, "latitude":courseLocation.latitude])) { (result) in
                switch result {
                case let .success(moyaResponse):
                    print(moyaResponse)
                    let json = JSON(data:moyaResponse.data)
                    completion(json)
                    break
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
        else{
            print("course error")
        }
    }
    
}
