//
//  HouseTableViewCell.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 08/10/2024.
//

import Foundation
import UIKit

final class HouseViewModelCell {
    private(set) var name: String
    private(set) var region: String
    private(set) var words: String

    init(house: House) {
        name = house.name
        region = house.region
        words = house.words
    }
}

final class HouseTableViewCell: UITableViewCell {
    static let reuseIdentifierCell = "HouseTableViewCell"

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var regionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var wordsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
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

        nameLabel.text = nil
        regionLabel.text = nil
        wordsLabel.text = nil
    }

    // MARK: - Setup Methods

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, regionLabel, wordsLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])

        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1), // 1 pixel height for the separator
        ])
    }

    func configure(with houseViewModel: HouseViewModelCell) {
        nameLabel.text = houseViewModel.name
        regionLabel.text = houseViewModel.region
        wordsLabel.text = houseViewModel.words

        if houseViewModel.words.isEmpty {
            wordsLabel.isHidden = true
        } else {
            wordsLabel.isHidden = false
            wordsLabel.text = houseViewModel.words
        }
    }

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.lightGray : UIColor.clear
        }
    }
}
