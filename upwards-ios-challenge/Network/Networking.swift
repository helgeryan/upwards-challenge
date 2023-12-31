//
//  Network.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

protocol Networking {
    func requestObject<T: Decodable>(_ router: UpwardsRouter, completion: @escaping (Result<T, Error>) -> ())
    func requestData(_ router: UpwardsRouter, completion: @escaping (Result<Data, Error>) -> ())
}
