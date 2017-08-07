//
//  GTEndpoints.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-01-28.
//  Copyright © 2017 markhall. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

enum GTEndpoints {
    case signUp(username: String, password: String)
    case login(username: String, password: String)
    case courseSearch(searchString: String)
    case stats
    case saveCourse(name: String, tees: [[String:Any?]], holes:[[String:Any?]], location: [String:Any?])
}

extension GTEndpoints: TargetType{
    var baseURL: URL {
        return URL(string: "http://localhost:3000/")!
    }
    var path: String {
        switch self {
        case .signUp(_, _):
            return "createuser"
        case .login(_,_):
            return "login"
        case .stats:
            return "overallStats"
        case .courseSearch(_):
            return "queryCourseWithName"
        case .saveCourse(_,_,_,_):
            return "saveCourse"
        }
    }
    var method: Moya.Method {
        switch self {
        case .signUp(_, _), .login(_, _), .stats, .courseSearch(_), .saveCourse(_,_,_,_):
            return .post
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .signUp(let email, let password), .login(let email, let password):
            return ["Email": email, "Password": password]
        case .stats:
            return ["Email": "golfguru@icloud.com"]
        case .courseSearch(let searchString):
            return ["name":searchString]
        case .saveCourse(let name, let tees, let holes, let location):
            return ["name": name, "tees": tees, "holes":holes, "location": location]
        }
    }
    var task: Task {
        switch self {
        case .signUp, .login, .stats, .courseSearch, .saveCourse:
            return .request
        }
    }
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .signUp(_, _), .login(_, _), .stats, .courseSearch(_), .saveCourse(_,_,_,_):
            return JSONEncoding.default
        }
    }
    
    var sampleData: Data {
        switch self {
        case .signUp(_, _), .login(_, _), .stats, .courseSearch(_), .saveCourse(_,_,_,_):
            return Data()
        }
    }
}
