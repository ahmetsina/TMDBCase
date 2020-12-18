//
//  GenreTarget.swift
//  TMDBCase
//
//  Created by AppLogist on 18.12.2020.
//

import Moya
import Foundation

enum GenreTarget {
    case movieList
}

extension GenreTarget: BaseTarget {
    var subDirectory: String { "genre" }
    var path: String { "movie/list" }
    var task: Task { .requestParameters(parameters: QueryRequest().dictionary, encoding: URLEncoding.queryString) }
}
