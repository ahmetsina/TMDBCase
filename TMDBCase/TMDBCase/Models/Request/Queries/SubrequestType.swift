//
//  SubrequestType.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Foundation

enum SubrequestType: String, Encodable, CaseIterable {
    case videos
    case credits
    case images
}

extension Collection where Element == SubrequestType {
    var stringWithComma : String { compactMap({ $0.rawValue }).joined(separator: ",") }
}
