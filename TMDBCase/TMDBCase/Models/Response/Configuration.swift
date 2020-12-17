//
//  Configuration.swift
//  TMDBCase
//
//  Created by AppLogist on 18.12.2020.
//

import Foundation

struct Configuration: Codable {
    struct ImageConfigs: Codable {
        let baseUrl: URL?
        let secureBaseUrl: URL?
        let backdropSizes: [String]?
        let logoSizes: [String]?
        let posterSizes: [String]?
        let profileSizes: [String]?
        let stillSizes: [String]?
    }
    let images: ImageConfigs?
}
extension Configuration {
    var baseImageURL: URL? { images?.secureBaseUrl }
    var backdropBaseImageURL: URL? { baseImageURL?.appendingPathComponent(images?.backdropSizes?.last ?? "") }
    var logoBaseImageURL: URL? { baseImageURL?.appendingPathComponent(images?.logoSizes?.last ?? "")}
    var posterBaseImageURL: URL? { baseImageURL?.appendingPathComponent(images?.posterSizes?.last ?? "")}
    var profileBaseImageURL: URL? { baseImageURL?.appendingPathComponent(images?.profileSizes?.last ?? "")}
}


