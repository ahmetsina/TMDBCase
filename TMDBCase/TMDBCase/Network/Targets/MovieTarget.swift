//
//  APITarget.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Moya
import Foundation

enum MovieTarget {
    case popular
    case details(_ request: QueryRequest)
}

extension MovieTarget: BaseTarget {
    var subDirectory: String { "movie" }
    var path: String {
        switch self {
            case .popular:
                return "popular"
            case .details(let request):
                return "/\(request.movieID ?? 0)"
        }
    }
    
    var task: Task {
        switch self {
            case .details(let request):
                return .requestParameters(parameters: request.dictionary, encoding: URLEncoding.queryString)
            default:
                return .requestParameters(parameters: QueryRequest().dictionary, encoding: URLEncoding.queryString)
        }
    }
}
