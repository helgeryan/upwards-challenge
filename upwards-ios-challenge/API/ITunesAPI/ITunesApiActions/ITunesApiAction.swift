//
//  ITunesApiAction.swift
//  nbaApp
//
//  Created by Ryan Helgeson on 8/2/23.
//

import Foundation

public enum ITunesApiAction {
    case getAlbums(count: Int)
}

extension ITunesApiAction: UpwardsRouter {
    var method: HTTPMethod {
        switch self {
        case .getAlbums:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getAlbums(let count) :
            return "api/v2/us/music/most-played/\(count)/albums.json"
        }
    }
    
    var baseUrl: String {
        return "https://rss.applemarketingtools.com/"
    }
    
    var parameters: [URLQueryItem]? {
        return nil
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
}
