//
//  SearchResults.swift
//  MyPhotos
//
//  Created by Алексей Пархоменко on 31/07/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation



struct SearchResult: Decodable {
    let total: Int
    let total_pages: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let height: Int
    let width: Int
    let urls: [URLKind.RawValue: String]
    
    enum URLKind: String, Codable {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

