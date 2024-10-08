//
//  HouseTableViewCell.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 08/10/2024.
//

import Foundation
import UIKit

class HouseViewModelCell {
    private(set) var name: String
    private(set) var region: String
    private(set) var words: String

    init(house: House) {
        name = house.name
        region = house.region
        words = house.words
    }
}

class HouseTableViewCell: UITableViewCell {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabels()
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

    private func setupLabels() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(regionLabel)
        contentView.addSubview(wordsLabel)
        
        // Set constraints for the labels
        NSLayoutConstraint.activate([

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            regionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            regionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            regionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            wordsLabel.topAnchor.constraint(equalTo: regionLabel.bottomAnchor, constant: 4),
            wordsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            wordsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            wordsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    // Configure the cell with house data
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
