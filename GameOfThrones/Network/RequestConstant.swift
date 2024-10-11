//
//  RequestConstant.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 09/10/2024.
//

import Foundation

enum RequestConstant {
    enum Server {
        static let scheme = "https"
        static let host = "anapioficeandfire.com"
        static let basePath = "/api"
    }

    enum Endpoints {
        static let books = "\(Server.basePath)/books"
        static let houses = "\(Server.basePath)/houses"
        static let characters = "\(Server.basePath)/characters"
    }
}
