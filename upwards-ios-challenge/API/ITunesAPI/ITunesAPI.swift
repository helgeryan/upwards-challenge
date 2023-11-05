//
//  ITunesAPI.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

final class ITunesAPI: ITunesAPIClientProtocol {
    
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func getTopAlbums(limit: Int = 10, completion: @escaping (Result<AlbumFeed, Error>) -> ())  {
        let router = ITunesApiAction.getAlbums(count: limit)
        network.requestObject(router, completion: completion)
    }
}
