//
//  GenericResults.swift
//  TMDBCase
//
//  Created by AppLogist on 16.12.2020.
//

import Foundation
struct GenericResults<T: Decodable>: Decodable {
       let results: [T]?
}
