//
//  JsonDecoder+UpwardsDate.swift
//  upwards-ios-challenge
//
//  Created by Ryan Helgeson on 11/4/23.
//

import Foundation

extension JSONDecoder {
    func configureUpwardsDateDecodingStrategy(error: Error) {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        self.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            
            throw error
        })
    }
}
