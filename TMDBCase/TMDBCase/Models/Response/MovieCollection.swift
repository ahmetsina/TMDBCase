//
//  MovieCollection.swift
//  TMDBCase
//
//  Created by AppLogist on 16.12.2020.
//

import Foundation

struct MovieCollection: Decodable {
    let id: Int?
    let name: String?
    let posterPath: String?
    let backdropPath: String?
}
