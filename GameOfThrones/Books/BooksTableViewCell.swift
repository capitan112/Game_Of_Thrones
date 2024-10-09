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
class BooksTableViewCell: UITableViewCell {
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
        label.font = UIFont.italicSystemFont(ofSize: 14)
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
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel, pagesLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func setupWith(bookViewModelCell: BookViewModelCell) {
        titleLabel.text = bookViewModelCell.name
        dateLabel.text = bookViewModelCell.released
        pagesLabel.text = bookViewModelCell.numberOfPages
    }
}
