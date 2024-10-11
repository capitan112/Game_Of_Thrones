//
//  House.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 08/10/2024.
//

import Foundation

struct House: Decodable {
    let name: String
    let region: String
    let words: String

    enum CodingKeys: String, CodingKey {
        case name
        case region
        case words
    }
}
