//
//  Movie.swift
//  TMDBCase
//
//  Created by AppLogist on 16.12.2020.
//

import Foundation

struct Movie: Decodable {
    let adult: Bool?
    private let backdropPath: String?
    let belongsToCollection: MovieCollection?
    let budget: Int?
    let genres: [Genre]?
    let genreIds: [Int]?
    let id: Int?
    let imdbId: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    private let posterPath: String?
    let revenue: Int?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let videos: GenericResults<Video>?
    let credits: Credits<Person,Person>?
}

extension Movie {
    var genresStringWithComma: String? {
        genreIds?.convertToGenres.compactMap({ $0.name }).joined(separator: ",")
    }
    
    var backdropURL: URL? {
        AppData.shared.config?.backdropBaseImageURL?.appendingPathComponent(backdropPath ?? "")
    }
    
    var posterURL: URL? {
        AppData.shared.config?.posterBaseImageURL?.appendingPathComponent(posterPath ?? "")
    }
}
