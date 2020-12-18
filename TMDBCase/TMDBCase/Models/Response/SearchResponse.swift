//
//  SearchResponse.swift
//  TMDBCase
//
//  Created by AppLogist on 18.12.2020.
//

import Foundation

enum MediaType: String, CaseIterable, Codable {
    case movie
    case person
    case tv
    case genre
}

struct SearchResponse: Codable {
    let adult: Bool?
    private let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let mediaType: MediaType?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    private let posterPath: String?
    let releaseDate: Date?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    private let profilePath: String?
    let knownFor: [SearchResponse]?
    let knownForDepartment: String?
}

extension SearchResponse {
    var backdropURL: URL? {
        AppData.shared.config?.backdropBaseImageURL?.appendingPathComponent(backdropPath ?? "")
    }
    
    var posterURL: URL? {
        AppData.shared.config?.posterBaseImageURL?.appendingPathComponent(posterPath ?? "")
    }
    
    var profileURL: URL? {
        AppData.shared.config?.profileBaseImageURL?.appendingPathComponent(profilePath ?? "")
    }
}
