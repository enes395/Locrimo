//
//  Location.swift
//  Locrimo
//
//  Created by Muhammed Enes Kılıçlı on 16.03.2023.
//

import Foundation

struct Location: Codable {
    var id: Int
    var name: String
    var type: String
    var dimension: String
    var residents: [String?]
    var url: String
    var created: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case type = "type"
        case dimension = "dimension"
        case residents = "residents"
        case url = "url"
        case created = "created"
    }
    
}
