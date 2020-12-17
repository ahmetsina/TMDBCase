//
//  QueryRequest.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Foundation

struct QueryRequest: Encodable {
    init(appendToResponse: [SubrequestType]? = nil) {
        self.appendToResponse = appendToResponse
    }
    
    let apiKey = APIConstants.apiKey
    let appendToResponse : [SubrequestType]?
}
