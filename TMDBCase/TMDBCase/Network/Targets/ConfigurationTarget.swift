//
//  ConfigurationTarget.swift
//  TMDBCase
//
//  Created by AppLogist on 18.12.2020.
//

import Moya
import Foundation

enum ConfigurationTarget {
    case getConfig
}

extension ConfigurationTarget: BaseTarget {
    var subDirectory: String { "" }
    var path: String { "configuration" }
    var task: Task { .requestParameters(parameters: QueryRequest().dictionary, encoding: URLEncoding.queryString) }
}




