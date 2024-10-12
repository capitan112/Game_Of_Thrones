//
//  HousesViewController.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 08/10/2024.
//

import UIKit

final class HousesViewController: RootViewController {
    private var housesViewModel: HousesViewModelType
    private let searchController = UISearchController(searchResultsController: nil)

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "imgHouses")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    init(viewModel: HousesViewModelType = HousesViewModel()) {
        housesViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImage()
        setupTableView()
        setUpSearchController()
        addActivityIndicator(center: view.center)
        startActivityIndicator()
        getHouses()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HouseTableViewCell.self, forCellReuseIdentifier: HouseTableViewCell.reuseIdentifierCell)
        tableView.accessibilityIdentifier = "HousesTableView"
    }

    private func setupBackgroundImage() {
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Houses"
        navigationItem.searchController = searchController
        navigationItem.preferredSearchBarPlacement = .stacked
        definesPresentationContext = true
    }

    private func getHouses() {
        housesViewModel.fetchHouses().done { [weak self] houses in
            self?.loadData(houses: houses)
        }.catch { error in
            debugPrint("Failed to fetch houses: \(error)")
            self.showAlertAndStopActivityIndicator()
        }
    }

    func loadData(houses: [House]) {
        housesViewModel.setUp(houses: houses)
        reload(tableView: tableView)
        stopActivityIndicator()
    }
}

// MARK: - UITableViewDataSource Methods

extension HousesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return housesViewModel.filteredHouses.count
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.alpha = 0

        UIView.animate(withDuration: 0.5, animations: {
            cell.alpha = 1
        })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HouseTableViewCell.reuseIdentifierCell, for: indexPath) as! HouseTableViewCell
        cell.configure(with: HouseViewModelCell(house: housesViewModel.filteredHouses[indexPath.row]))

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 80
    }
}

extension HousesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        housesViewModel.filtering(with: searchText)
        tableView.reloadData()
    }
}
