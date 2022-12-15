//
//  ApiModel.swift
//  PublicApis
//
//  Created by Tomasz Ogrodowski on 15/12/2022.
//

import Foundation

struct EntriesApiResponse: Codable {
    let count: Int
    let entries: [Entry]
}

struct Entry: Codable {
    let name: String
    let description: String
    let auth: String
    let https: Bool
    let cors: String
    let link: String
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case name = "API"
        case description = "Description"
        case auth = "Auth"
        case https = "HTTPS"
        case cors = "Cors"
        case link = "Link"
        case category = "Category"
    }
}
