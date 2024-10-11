//
//  CharactersViewModel.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 11/10/2024.
//

import Foundation
import PromiseKit

protocol CharactersViewModelType {
    var characters: [Character] { get }
    var filteredCharacters: [Character] { get }

    func fetchCharacters() -> Promise<[Character]>
    func filtering(with target: String)
    func setUp(characters: [Character])
}

final class CharactersViewModel: RootViewModel, CharactersViewModelType {
    private(set) var characters: [Character] = []
    private(set) var filteredCharacters: [Character] = []

    func fetchCharacters() -> Promise<[Character]> {
        do {
            return try networkService.fetchCharacters().then { characters in
                self.characters = characters
                self.filteredCharacters = characters
                return Promise.value(characters)
            }
        } catch {
            return Promise(error: error)
        }
    }

    func setUp(characters: [Character]) {
        self.characters = characters
        filteredCharacters = characters
    }

    func discardSearching() {
        filteredCharacters = characters
    }

    func filtering(with target: String) {
        if target.isEmpty {
            discardSearching()
            return
        }

        filteredCharacters = characters.filter { character in
            character.name.lowercased().contains(target.lowercased())
        }
    }
}
