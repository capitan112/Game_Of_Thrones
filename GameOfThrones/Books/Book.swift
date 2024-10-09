//
//  Book.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 09/10/2024.
//

import Foundation

struct Book: Decodable {
    let url: String
    let name: String
    let isbn: String
    let authors: [String]
    let numberOfPages: Int
    let publisher: String
    let country: String
    let mediaType: String
    let released: Date
    let characters: [String]
}
