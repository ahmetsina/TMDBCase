//
//  BaseTarget.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Moya
import Foundation

protocol BaseTarget: TargetType {
    var subDirectory: String { get }
}

extension BaseTarget {
    
    var baseURL: URL { APIConstants.baseURL.appendingPathComponent(subDirectory) }
    var headers: [String : String]? { ["Content-Type": "application/json"] }
    var sampleData: Data { Data() }
    var method: Moya.Method { .get }
}
