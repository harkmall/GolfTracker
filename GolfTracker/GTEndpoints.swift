//
//  GTEndpoints.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-01-28.
//  Copyright © 2017 markhall. All rights reserved.
//

import Foundation
import Moya


enum GTEndpoints {
    case signUp(username: String, password: String)
    case login(username: String, password: String)
    case stats
}

extension GTEndpoints: TargetType{
    var baseURL: URL {
        return URL(string: "http://192.168.2.10:3000/")!
    }
    var path: String {
        switch self {
        case .signUp(_, _):
            return "createuser"
        case .login(_,_):
            return "login"
        case .stats:
            return "overallStats"
        }
    }
    var method: Moya.Method {
        switch self {
        case .signUp(_, _), .login(_, _), .stats:
            return .post
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .signUp(let email, let password), .login(let email, let password):
            return ["Email": email, "Password": password]
        case .stats:
            return ["Email": "golfguru@icloud.com"]
        }
    }
    var task: Task {
        switch self {
        case .signUp, .login, .stats:
            return .request
        }
    }
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .signUp(_, _), .login(_, _), .stats:
            return JSONEncoding.default
        }
    }
    
    var sampleData: Data {
        switch self {
        case .signUp(_, _), .login(_, _), .stats:
            return Data()
        }
    }
}
