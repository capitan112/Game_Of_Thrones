//
//  DateFormatter+Iso8601Full.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 08/10/2024.
//

import Foundation

protocol DateFormatterServiceProtocol {
    var iso8601FullFormatter: DateFormatter { get }
    var monthYearFormatter: DateFormatter { get }
}

class DateFormatterService: DateFormatterServiceProtocol {
    
    init() { }

    let iso8601FullFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM yyyy"

        return formatter
    }()
}
