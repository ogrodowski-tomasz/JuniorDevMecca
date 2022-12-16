//
//  ApiTableViewCell.swift
//  PublicApis
//
//  Created by Tomasz Ogrodowski on 15/12/2022.
//

import Foundation
import UIKit

class ApiTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ApiTableViewCell"
    
    let apiNameLabel = UILabel()
    let categoryLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        styleCell()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func styleCell() {
        backgroundColor = appColor
        
        apiNameLabel.translatesAutoresizingMaskIntoConstraints = false
        apiNameLabel.text = "<API NAME>"
        apiNameLabel.textColor = .label
        apiNameLabel.numberOfLines = 1
        apiNameLabel.font = UIFont.futuraFont(ofSize: 18)
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.text = "<CATEGORY NAME>"
        categoryLabel.textAlignment = .right
        categoryLabel.textColor = .secondaryLabel
        categoryLabel.numberOfLines = 1
        categoryLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "<DESCRIPTION NAME>"
        descriptionLabel.textColor = .label.withAlphaComponent(0.75)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    private func layout() {
        addSubview(apiNameLabel)
        addSubview(categoryLabel)
        addSubview(descriptionLabel)
        
        // CATEGORY NAME
        NSLayoutConstraint.activate([
            categoryLabel.centerYAnchor.constraint(equalTo: apiNameLabel.centerYAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: categoryLabel.trailingAnchor, multiplier: 1),
            categoryLabel.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        // API NAME
        NSLayoutConstraint.activate([
            apiNameLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            apiNameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            categoryLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: apiNameLabel.trailingAnchor, multiplier: 1)
        ])
        
        // DESCRIPTION NAME
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: apiNameLabel.bottomAnchor, multiplier: 1),
            descriptionLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: descriptionLabel.trailingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: descriptionLabel.bottomAnchor, multiplier: 1)
        ])
    }
    
    func configure(with viewModel: ViewModel) {
        apiNameLabel.text = viewModel.name
        categoryLabel.text = viewModel.category
        descriptionLabel.text = viewModel.description
    }
}

extension ApiTableViewCell {
    struct ViewModel {
        let name: String
        let category: String
        let description: String
        let link: String
    }
}
