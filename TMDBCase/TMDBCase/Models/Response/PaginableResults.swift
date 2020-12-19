//
//  PaginableResults.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Foundation

struct PaginableResults<T: Decodable>: Decodable {
    let page: Int?
    let results: T?
    let totalPages: Int?
    let totalResults: Int?
}
