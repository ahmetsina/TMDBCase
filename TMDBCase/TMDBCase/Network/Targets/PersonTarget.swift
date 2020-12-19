//
//  PersonTarget.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Moya
import Foundation

enum PersonTarget {
    case details(_ request: QueryRequest)
}

extension PersonTarget: BaseTarget {
    var subDirectory: String { "person" }
    var path: String {
        switch self {
            case .details(let request):
                return "/\(request.personID ?? 0)"
        }
    }
    var task: Task {
        switch self {
            case .details(let request):
                return .requestParameters(parameters: request.dictionary, encoding: URLEncoding.queryString)
        }
    }
}
