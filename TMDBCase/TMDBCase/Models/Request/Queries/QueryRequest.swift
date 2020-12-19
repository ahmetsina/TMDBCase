//
//  QueryRequest.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Foundation

struct QueryRequest: Encodable {
    init(appendToResponse: [SubrequestType]? = nil,
         movieID: Int? = nil,
         personID: Int? = nil) {
        self.appendToResponse = appendToResponse?.stringWithComma
        self.movieID = movieID
        self.personID = personID
    }
    
    let apiKey = APIConstants.apiKey
    let appendToResponse : String?
    let movieID: Int?
    let personID: Int?
}
