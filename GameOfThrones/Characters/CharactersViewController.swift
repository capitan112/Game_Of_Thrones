//
//  CharactersViewController.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 11/10/2024.
//

import Foundation
import UIKit

final class CharactersViewController: RootViewController {
    private var charactersViewModel: CharactersViewModelType
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchWorkItem: DispatchWorkItem?

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "imgCharacters")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    init(viewModel: CharactersViewModelType = CharactersViewModel()) {
        charactersViewModel = viewModel
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
        getCharacters()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifierCell)
        tableView.accessibilityIdentifier = "CharactersTableView"
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
        searchController.searchBar.placeholder = "Search Characters"
        navigationItem.searchController = searchController
        navigationItem.preferredSearchBarPlacement = .stacked
        definesPresentationContext = true
    }

    private func getCharacters() {
        charactersViewModel.fetchCharacters().done { [weak self] characters in
            self?.loadData(characters: characters)
        }.catch { error in
            debugPrint("Failed to fetch houses: \(error)")
            self.showAlertAndStopActivityIndicator()
        }
    }

    func loadData(characters: [Character]) {
        charactersViewModel.setUp(characters: characters)
        reload(tableView: tableView)
        stopActivityIndicator()
    }
}

// MARK: - UITableViewDataSource Methods

extension CharactersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return charactersViewModel.filteredCharacters.count
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.alpha = 0

        UIView.animate(withDuration: 0.5, animations: {
            cell.alpha = 1
        })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifierCell, for: indexPath) as! CharacterTableViewCell
        cell.configure(with: CharacterViewModelCell(character: charactersViewModel.filteredCharacters[indexPath.row]))

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 120
    }
}

extension CharactersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        searchWorkItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            self?.charactersViewModel.filtering(with: searchText)
            self?.tableView.reloadData()
        }

        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }
}
