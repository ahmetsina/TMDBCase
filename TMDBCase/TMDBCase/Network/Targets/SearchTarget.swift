//
//  SearchTarget.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Moya
import Foundation

enum SeaarchTarget {
    case multi(_ query: String)
}

extension SeaarchTarget: BaseTarget {
    var subDirectory: String { "search" }
    var path: String { "multi" }
    var task: Task {
        switch self {
            case .multi(let query):
                return .requestParameters(parameters: ["query": query], encoding: URLEncoding.queryString)
        }
    }
}

