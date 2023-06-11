//
//  SearchLocation.swift
//  Locrimo
//
//  Created by Muhammed Enes Kılıçlı on 16.03.2023.
//

import Foundation

struct SearchLocation: Codable {
    var info: LocationRequestInfo
    var results: [Location]
    
    enum CodingKeys: String, CodingKey {
        case info = "info"
        case results = "results"
    }
}

struct LocationRequestInfo: Codable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case pages = "pages"
        case next = "next"
        case prev = "prev"
    }
}
