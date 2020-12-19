//
//  API.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Foundation

final class API {
    let movie = BaseAPI<MovieTarget>()
    let person = BaseAPI<PersonTarget>()
    
    deinit {
        debugPrint("Deinit")
    }
}
