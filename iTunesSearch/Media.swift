//
//  Media.swift
//  iTunesSearch
//
//  Created by Consultant on 5/6/20.
//  Copyright © 2020 Avellaneda. All rights reserved.
//

import Foundation

struct MediaResults: Codable {
    var results: [Media]
    
    private enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct Media: Codable {
    var trackId: String?
    var kind: String?
    var artistName: String?
    var collectionName: String?
    var trackViewUrl: String?
    var previewUrl: String?
    var primaryGenreName: String?
    var artworkUrl: String?

    private enum CodingKeys: String, CodingKey {
        case trackId
        case kind
        case artistName
        case collectionName
        case trackViewUrl
        case previewUrl
        case primaryGenreName
        case artworkUrl = "artworkUrl100"
    }
}
