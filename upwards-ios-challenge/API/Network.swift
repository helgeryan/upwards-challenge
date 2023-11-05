//
//  Network.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation
import os.log

fileprivate let general = OSLog(subsystem: "com.upwards.challenge", category: "general")

final class Network: NSObject, Networking, URLSessionDelegate {
    
    private let sessionConfig: URLSessionConfiguration
    private let decoder = JSONDecoder()
    private lazy var session: URLSession = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
    
    init(sessionConfig: URLSessionConfiguration) {
        self.sessionConfig = sessionConfig
        super.init()
        decoder.configureUpwardsDateDecodingStrategy(error: APIErrors.custom("Failed to decode date"))
    }
    
    func requestObject<T: Decodable>(_ router: UpwardsRouter, completion: @escaping (Result<T, Error>) -> ()) {
        requestData(router) { res in
            completion(
                res.flatMap { data in
                    Result {
                        try self.decoder.decode(T.self, from: data)
                    }
                }
            )
        }
    }
    
    func requestData(_ router: UpwardsRouter, completion: @escaping (Result<Data, Error>) -> ()) {
        let task = session.dataTask(with: try! addLog(router).asURLRequest()) { (data, res, err) in
            guard
                let httpResponse = res as? HTTPURLResponse,
                let d = data,
                (200..<300) ~= httpResponse.statusCode
            else {
                completion(.failure(APIErrors.invalidResponse(err)))
                return
            }
            
            completion(.success(d))
        }
        task.resume()
    }

    private func addLog(_ router: UpwardsRouter) -> UpwardsRouter {
        os_log("%s", log: general, type: .debug, router.description)
        return router
    }
}
