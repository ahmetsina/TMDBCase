//
//  Person.swift
//  TMDBCase
//
//  Created by AppLogist on 16.12.2020.
//

import Foundation

struct Person: Decodable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    private let profilePath: String?
    let castId: Int?
    let character: String?
    let creditId: String?
    let alsoKnownAs: [String]?
    let biography: String?
    let birthday: Date?
    let homepage: URL?
    let imdbId: String?
    let placeOfBirth: String?
    let credits: Credits<Movie, Movie>?
}


extension Person {
    var profileURL: URL? {
        AppData.shared.config?.profileBaseImageURL?.appendingPathExtension(profilePath ?? "")
    }
}
