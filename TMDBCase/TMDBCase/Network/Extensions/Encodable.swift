//
//  Encodable.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any] {
        let decoder = JSONEncoder()
        decoder.dateEncodingStrategy = .iso8601
        decoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? decoder.encode(self) else { return [:] }
        let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        return dict ?? [:]
    }
}
