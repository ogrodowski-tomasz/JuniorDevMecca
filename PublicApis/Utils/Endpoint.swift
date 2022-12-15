//
//  Endpoint.swift
//  PublicApis
//
//  Created by Tomasz Ogrodowski on 15/12/2022.
//

import Foundation

// https://api.publicapis.org/entries
// https://api.publicapis.org/categories

enum Endpoint {
    case entries
    case categories
}

extension Endpoint {
    var host: String { "api.publicapis.org" }
    
    var path: String {
        switch self {
        case .entries:
            return "/entries"
        case .categories:
            return "/categories"
        }
    }
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        print("DEBUG: Calling url: ", urlComponents.url!)
        return urlComponents.url
    }
}
