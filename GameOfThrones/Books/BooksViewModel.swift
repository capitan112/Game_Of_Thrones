//
//  BooksViewModel.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 09/10/2024.
//

import Foundation
import UIKit
import PromiseKit

protocol BooksViewModelType {
    var books: [Book] { get }
    func fetchBooks() -> Promise<[Book]>
    func setUp(books: [Book])
}

final class BooksViewModel: RootViewModel, BooksViewModelType {
    private(set) var books: [Book] = []
    
    func fetchBooks() -> Promise<[Book]> {
        do {
            return try networkService.fetchBooks().then { books in
                self.books = books
                return Promise.value(books)
            }
        } catch {
            return Promise(error: error)
        }
    }
    
    func setUp(books: [Book]) {
        self.books = books
    }
}
