//
//  BooksTableViewCell.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 09/10/2024.
//

import Foundation
import UIKit

final class BookViewModelCell {
    private(set) var name: String
    private(set) var released: String
    private(set) var numberOfPages: String

    init(book: Book, dateFormatterService: DateFormatterServiceProtocol = DateFormatterService()) {
        name = book.name
        released = "Released: " + dateFormatterService.monthYearFormatter.string(from: book.released)
        numberOfPages = String(book.numberOfPages) + " " + "pages"
    }
}

// MARK: - BooksTableViewCell

final class BooksTableViewCell: UITableViewCell {
    static let reuseIdentifierCell = "BooksTableViewCell"

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var pagesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        dateLabel.text = ""
        pagesLabel.text = ""
    }

    private func setupUI() {
        let titleAndPagesStackView = UIStackView(arrangedSubviews: [titleLabel, pagesLabel])
        titleAndPagesStackView.axis = .horizontal
        titleAndPagesStackView.spacing = 8
        titleAndPagesStackView.translatesAutoresizingMaskIntoConstraints = false

        let verticalStackView = UIStackView(arrangedSubviews: [titleAndPagesStackView, dateLabel])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 4
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(verticalStackView)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])

        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }

    func setupWith(bookViewModelCell: BookViewModelCell) {
        titleLabel.text = bookViewModelCell.name
        dateLabel.text = bookViewModelCell.released
        pagesLabel.text = bookViewModelCell.numberOfPages
    }
}
