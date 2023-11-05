//
//  ApiClientProtocol.swift
//  upwards-ios-challenge
//
//  Created by Ryan Helgeson on 11/4/23.
//

import Foundation

protocol APIClientProtocol {
    func getTopAlbums(limit: Int, completion: @escaping (Result<AlbumFeed, Error>) -> ())
}
