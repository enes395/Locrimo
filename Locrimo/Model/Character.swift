//
//  Character.swift
//  Locrimo
//
//  Created by Muhammed Enes Kılıçlı on 16.03.2023.
//

import Foundation

struct Character: Codable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var origin: CharacterOrigin
    var location: CharacterLocation
    var image: String
    var episode: [String]
    var url: String
    var created: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status = "status"
        case species = "species"
        case type = "type"
        case gender = "gender"
        case origin = "origin"
        case location = "location"
        case image = "image"
        case episode = "episode"
        case url = "url"
        case created = "created"
    }
}

struct CharacterOrigin: Codable {
    var name: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}

struct CharacterLocation: Codable {
    var name: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}
