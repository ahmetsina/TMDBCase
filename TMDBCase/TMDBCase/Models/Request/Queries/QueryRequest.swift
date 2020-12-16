//
//  QueryRequest.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Foundation

struct QueryRequest: Encodable {
    let appendToResponse : [SubrequestType]?
}
