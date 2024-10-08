//
//  ViewModel.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 08/10/2024.
//

import Foundation
import PromiseKit

protocol HousesViewModelType {
    var houses: [House] { get }
    var filteredHouses: [House] { get }
    func fetchItems() -> Promise<[House]>
    func filtering(with target: String)
    func setUp(houses: [House])
    func discardSearching()
}

class HousesViewModel: RootViewModel, HousesViewModelType {
    
    private(set) var houses: [House] = []
    private(set) var filteredHouses: [House] = []
    func fetchItems() -> Promise<[House]> {
        do {
            return try networkService.fetchHouses().then { houses in
                self.houses = houses
                return Promise.value(houses)
            }
        } catch {
            return Promise(error: error)
        }
    }

    func setUp(houses: [House]) {
        self.houses = houses
        filteredHouses = houses
    }

    func discardSearching() {
        filteredHouses = houses
    }

    func filtering(with target: String) {
        if target.isEmpty {
            discardSearching()

            return
        }

        filteredHouses = houses.filter { (house: House) -> Bool in
            house.name.lowercased().range(of: target, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
    }
}
