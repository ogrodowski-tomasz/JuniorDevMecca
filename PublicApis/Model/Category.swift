//
//  Category.swift
//  PublicApis
//
//  Created by Tomasz Ogrodowski on 15/12/2022.
//

import Foundation

struct CategoriesApiResponse: Codable {
    let count: Int
    let categories: [String]
}
