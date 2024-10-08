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
    var filteredHouses: [House] { get set }
    func fetchItems() -> Promise<[House]>
    func filtering(with target: String)
    func setUp(houses: [House])
    func discardSearching()
}

class HousesViewModel: RootViewModel, HousesViewModelType {
    
    private(set) var houses: [House] = []
    var filteredHouses: [House] = []
    
    func fetchItems() -> Promise<[House]> {
        do {
            return try networkService.fetchHouses().then { houses in
                self.houses = houses
                self.filteredHouses = houses
                return Promise.value(houses)
            }
        } catch {
            return Promise(error: error)
        }
    }

    func setUp(houses: [House]) {
        self.houses = houses
        self.filteredHouses = houses
    }

    func discardSearching() {
        filteredHouses = houses
    }

    func filtering(with target: String) {
        if target.isEmpty {
            discardSearching()
            return
        }

        filteredHouses = houses.filter { house in
            house.name.lowercased().contains(target.lowercased())
        }
    }
}

