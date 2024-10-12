//
//  CharacterTableViewCell.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 11/10/2024.
//

import Foundation
import UIKit

final class CharacterViewModelCell {
    private let character: Character

    init(character: Character) {
        self.character = character
    }

    var name: String {
        return character.name
    }

    var culture: String {
        return character.culture
    }

    var born: String {
        return character.born
    }

    var died: String {
        return character.died
    }

    private let seasonDict = [
        "Season 1": "I",
        "Season 2": "II",
        "Season 3": "III",
        "Season 4": "IV",
        "Season 5": "V",
        "Season 6": "VI",
        "Season 7": "VII",
        "Season 8": "VIII",
    ]

    var seasons: String {
        var result = [String]()
        for index in 0 ..< character.tvSeries.count {
            if let season = seasonDict[character.tvSeries[index]] {
                result.append(season)
            }

            if index < character.tvSeries.count - 1 {
                result[index] += ","
            }
        }

        return result.joined()
    }
}

final class CharacterTableViewCell: UITableViewCell {
    static let reuseIdentifierCell = "CharacterTableViewCell"

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var cultureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var bornLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var diedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var seasonTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var seasonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
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
        nameLabel.text = nil
        cultureLabel.text = nil
        bornLabel.text = nil
        diedLabel.text = nil
        seasonLabel.text = nil
    }

    func configure(with characterViewModelCell: CharacterViewModelCell) {
        nameLabel.text = "Name: " + characterViewModelCell.name
        cultureLabel.text = "Culture: " + characterViewModelCell.culture
        bornLabel.text = "Born: " + characterViewModelCell.born
        diedLabel.text = "Died: " + characterViewModelCell.died
        seasonTitleLabel.text = "Seasons"
        seasonLabel.text = characterViewModelCell.seasons
    }

    private func setupUI() {
        let leftStackView = UIStackView(arrangedSubviews: [nameLabel, cultureLabel, bornLabel, diedLabel])
        leftStackView.axis = .vertical
        leftStackView.alignment = .leading
        leftStackView.spacing = 4
        leftStackView.translatesAutoresizingMaskIntoConstraints = false

        let rightStackView = UIStackView(arrangedSubviews: [seasonTitleLabel, seasonLabel])
        rightStackView.axis = .vertical
        rightStackView.alignment = .trailing
        rightStackView.spacing = 4
        rightStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(leftStackView)
        contentView.addSubview(rightStackView)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            leftStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            leftStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            rightStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            rightStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.lightGray : UIColor.clear
        }
    }
}
