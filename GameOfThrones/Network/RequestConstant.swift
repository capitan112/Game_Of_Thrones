//
//  RequestConstant.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 09/10/2024.
//

import Foundation

struct RequestConstant {
    
    struct Server {
        static let scheme = "https"
        static let host = "anapioficeandfire.com"
        static let basePath = "/api"
    }
    
    struct Endpoints {
        static let books = "\(Server.basePath)/books"
        static let houses = "\(Server.basePath)/houses"
        static let characters = "\(Server.basePath)/characters"
    }
}
