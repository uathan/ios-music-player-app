//
//  Music.swift
//  MusicPlayer
//
//  Created by Nathan Jamrog on 2024-04-18.
//

import Foundation


enum Section{
    case main
}

struct Albums: Codable {
    var results: [Albums]
}

struct Music: Codable, Hashable {
    var albumId: Int
    var albumName: String
    var artistName: String
    var collectionId: String
    var artworkUrl100: String
}
