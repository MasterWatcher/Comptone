//
//  ITunesAPI.swift
//  Comptone
//
//  Created by Anastasia Goncharova on 31/05/2019.
//  Copyright © 2019 Anton Goncharov. All rights reserved.
//

import Foundation
import Moya

enum ITunesAPI {
    case search(term: String)
}

extension ITunesAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://itunes.apple.com")!
    }
    
    var path: String {
        return "/search"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch  self {
        case let .search(term):
            let parameters = ["media": "music", "entity": "musicTrack", "country": "RU", "term": term]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
