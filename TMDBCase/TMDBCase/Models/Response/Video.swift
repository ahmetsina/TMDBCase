//
//  Video.swift
//  TMDBCase
//
//  Created by AppLogist on 16.12.2020.
//

import Foundation

struct Video: Decodable {
    let id: String?
    let iso6391: String?
    let iso31661: String?
    let key: String?
    let name: String?
    let site: String?
    let size: Int?
    let type: String?
}
