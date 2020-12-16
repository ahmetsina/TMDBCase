//
//  Movie.swift
//  TMDBCase
//
//  Created by AppLogist on 16.12.2020.
//

import Foundation

struct Movie: Decodable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: MovieCollection?
    let budget: Int?
    let genres: [Genre]?
    let genreIDs: [Int]?
    let homepage: URL?
    let id: Int?
    let imdbId: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: Date?
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
