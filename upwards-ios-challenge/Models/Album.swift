//
//  Album.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

// MARK: - Album
struct Album: Decodable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case artworkUrl100
        case artistName
        case releaseDate
    }
    
    var id: String
    var name: String
    var artworkUrl100: String?
    var artistName: String
    var releaseDate: Date
    
    var isNew: Bool {
        let date = Date() // Current Date
        if let days = Calendar.current.dateComponents([.day], from: self.releaseDate, to: date).day {
            // If the day is in the future, it is new
            return days < 0
        } else {
            return false
        }
    }
    
    static func == (lhs: Album, rhs: Album) -> Bool {
        return
            lhs.id == rhs.id
    }
}

// MARK: - AlbumFeed
struct AlbumFeed: Decodable {
    struct Feed: Decodable {
        var results: [Album]
    }
    
    var feed: Feed
}
