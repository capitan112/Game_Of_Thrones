//
//  BooksViewController.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 09/10/2024.
//

import Foundation
import PromiseKit
import UIKit

// MARK: - BooksViewController

final class BooksViewController: RootViewController {
    private var booksViewModel: BooksViewModelType

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "imgBooks")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    init(viewModel: BooksViewModelType = BooksViewModel()) {
        booksViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBackgroundImage()
        addActivityIndicator(center: view.center)
        startActivityIndicator()
        getBooks()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.register(BooksTableViewCell.self, forCellReuseIdentifier: BooksTableViewCell.reuseIdentifierCell)
        tableView.accessibilityIdentifier = "BooksTableView"
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

    private func getBooks() {
        booksViewModel.fetchBooks().done { [weak self] books in
            self?.loadData(books: books)
        }.catch { error in
            debugPrint("Failed to fetch houses: \(error)")
            self.showAlertAndStopActivityIndicator()
        }
    }

    func loadData(books: [Book]) {
        booksViewModel.setUp(books: books)
        reload(tableView: tableView)
        stopActivityIndicator()
    }

    private func loadData() {
        stopActivityIndicator()
    }

    private func errorAlert() {
        showAlertAndStopActivityIndicator()
    }
}

// MARK: - UITableViewDataSource

extension BooksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return booksViewModel.books.count
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.alpha = 0

        UIView.animate(withDuration: 0.5, animations: {
            cell.alpha = 1
        })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.reuseIdentifierCell,
                                                       for: indexPath) as? BooksTableViewCell
        else {
            return UITableViewCell()
        }
        cell.setupWith(bookViewModelCell: BookViewModelCell(book: booksViewModel.books[indexPath.row]))

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
