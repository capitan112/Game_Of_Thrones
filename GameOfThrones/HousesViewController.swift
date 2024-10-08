//
//  ViewController.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 08/10/2024.
//


import UIKit

class HousesViewController: RootViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    private var houses: [House] = []
    private var filteredItems: [House] = []
    private var housesViewModel: HousesViewModelType = HousesViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configTableView()
        setUpSearchController()
        setupConstraints()
        
        getHouses()
        addActivityIndicator(center: view.center)
    }
    
    private func configView() {
        view.backgroundColor = .white
    }
    
    private func configTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HouseCell")
    }
    
    private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Houses"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func getHouses() {
        housesViewModel.fetchItems().done { [weak self] houses in
            self?.houses = houses
            self?.filteredItems = houses
            self?.tableView.reloadData()
        }.catch { error in
            debugPrint("Failed to fetch houses: \(error)")
            self.showAlertAndStopActivityIndicator()
        }
    }
    
    // Set up Auto Layout constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return filteredItems.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "HouseCell", for: indexPath)
           
           let house = filteredItems[indexPath.row]
           cell.textLabel?.text = house.name
           cell.detailTextLabel?.text = house.region
           
           return cell
       }
       
       // MARK: - UISearchResultsUpdating
       func updateSearchResults(for searchController: UISearchController) {
           guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
               filteredItems = houses
               tableView.reloadData()
               return
           }
           
           filteredItems = houses.filter { house in
               return house.name.lowercased().contains(searchText.lowercased())
           }
           
           tableView.reloadData()
       }
}

