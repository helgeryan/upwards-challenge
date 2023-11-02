//
//  APIErrors.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

enum APIErrors: LocalizedError {
    case custom(String)
    case invalidURL(String)
    case invalidDate(String)
    case invalidParameters([URLQueryItem])
    case invalidResponse(Error?)
    
    var localizedDescription: String {
        switch self {
        case .custom(let string):
            return "API Error: \(string)"
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .invalidDate(let dateString):
            return "Invalid Date String: \(dateString)"
        case .invalidResponse(let error):
            return "Invalid API Response: \(error?.localizedDescription ?? "")"
        case .invalidParameters(let parameters):
            return "Invalid Parameters: \(parameters)"
        }
    }
}
