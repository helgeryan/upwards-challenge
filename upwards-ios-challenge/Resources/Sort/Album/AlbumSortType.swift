//
//  AlbumSortType.swift
//  upwards-ios-challenge
//
//  Created by Ryan Helgeson on 11/2/23.
//

import Foundation

enum AlbumSortType: CaseIterable, SortType {
    case albumId
    case title
    case artist
    
    var title: String {
        switch self {
        case .albumId:
            return "Album"
        case .title:
            return "Title"
        case .artist:
            return "Artist"
        }
    }
    
    var sort: (Album, Album) -> Bool {
        switch self {
        case .albumId:
            return { return $0.id < $1.id }
        case .title:
            // Lowercase in case the album
            return { return $0.name.lowercased() < $1.name.lowercased() }
        case .artist:
            return { return $0.artistName.lowercased() < $1.artistName.lowercased() }
        }
    }
}
