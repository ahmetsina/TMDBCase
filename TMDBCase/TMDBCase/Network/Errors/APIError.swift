//
//  APIError.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Foundation

struct APIError: Decodable {
    let statusCode: Int?
    let statusMessage: String?
    let success: Bool?
}
