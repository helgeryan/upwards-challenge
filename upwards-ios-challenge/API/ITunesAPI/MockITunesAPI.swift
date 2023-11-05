//
//  MockITunesAPI.swift
//  upwards-ios-challenge
//
//  Created by Ryan Helgeson on 11/4/23.
//

import Foundation

final class MockITunesAPI: ITunesAPIClientProtocol {
    func getTopAlbums(limit: Int = 10, completion: @escaping (Result<AlbumFeed, Error>) -> ())  {
        getMockData(mockFileName: "GetITunesMockResponse", completion: completion)
    }
    
    func getMockData<T: Decodable>(mockFileName: String, completion: @escaping (Result<T, Error>) -> ()) {
        let url = Bundle.main.url(forResource: mockFileName, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.configureUpwardsDateDecodingStrategy(error: APIErrors.custom("Failed to decode date"))
        
        let json = try! decoder.decode(T.self, from: data)
        
        completion(.success(json))
    }
}
