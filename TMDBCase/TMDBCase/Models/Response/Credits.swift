//
//  Credit.swift
//  TMDBCase
//
//  Created by AppLogist on 16.12.2020.
//

import Foundation
struct Credits<Cast: Decodable, Crew: Decodable>: Decodable {
    let cast: [Cast]?
    let crew: [Crew]?
}
