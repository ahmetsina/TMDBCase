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
    private let posterPath: String?
    private let backdropPath: String?
}

extension MovieCollection {
    var backdropURL: URL? {
        AppData.shared.config?.backdropBaseImageURL?.appendingPathComponent(backdropPath ?? "")
    }
    
    var posterURL: URL? {
        AppData.shared.config?.posterBaseImageURL?.appendingPathComponent(posterPath ?? "")
    }
}
