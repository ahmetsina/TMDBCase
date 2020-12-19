//
//  Genre.swift
//  TMDBCase
//
//  Created by AppLogist on 16.12.2020.
//

import Foundation

struct Genre: Decodable {
    let id: Int?
    let name: String?
}

extension Collection where Element == Int {
    var convertToGenres : [Genre] {
        var tmpGenre : [Genre] = []
        self.forEach({ (genreId) in
            if let genre = AppData.shared.genres.first(where: { $0.id == genreId }) {
                tmpGenre.append(genre)
            }
        })
        return tmpGenre
    }
}
