//
//  SkeletonCell.swift
//  PublicApis
//
//  Created by Tomasz Ogrodowski on 16/12/2022.
//

import Foundation
import UIKit

extension SkeletonCell: SkeletonLoadable { }

class SkeletonCell: UITableViewCell {
    static let reuseIdentifier = "SkeletonCell"
    
    let apiNameLabel = UILabel()
    let categoryLabel = UILabel()
    let descriptionLabel = UILabel()
    
    let apiNameLayer = CAGradientLayer()
    let categoryLayer = CAGradientLayer()
    let descriptionLayer = CAGradientLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupLayers()
        setupAnimation()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        apiNameLayer.frame = apiNameLabel.bounds
        apiNameLayer.cornerRadius = apiNameLabel.bounds.height/2
        
        categoryLayer.frame = categoryLabel.bounds
        categoryLayer.cornerRadius = categoryLabel.bounds.height/2
        
        descriptionLayer.frame = descriptionLabel.bounds
        descriptionLayer.cornerRadius = descriptionLabel.bounds.height/2
    }
    
    private func setup() {
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
    
    private func setupLayers() {
        apiNameLayer.startPoint = CGPoint(x: 0, y: 0.5)
        apiNameLayer.endPoint = CGPoint(x: 1, y: 0.5)
        apiNameLabel.layer.addSublayer(apiNameLayer)
        
        categoryLayer.startPoint = CGPoint(x: 0, y: 0.5)
        categoryLayer.endPoint = CGPoint(x: 1, y: 0.5)
        categoryLabel.layer.addSublayer(categoryLayer)
        
        descriptionLayer.startPoint = CGPoint(x: 0, y: 0.5)
        descriptionLayer.endPoint = CGPoint(x: 1, y: 0.5)
        descriptionLabel.layer.addSublayer(descriptionLayer)
    }
    
    private func setupAnimation() {
        let apiNameGroup = makeAnimationGroup()
        apiNameGroup.beginTime = 0.0
        apiNameLayer.add(apiNameGroup, forKey: "backgroundColor")
        
        let categoryGroup = makeAnimationGroup(previousGroup: apiNameGroup)
        categoryLayer.add(categoryGroup, forKey: "backgroundColor")
        
        let descriptionGroup = makeAnimationGroup(previousGroup: categoryGroup)
        descriptionLayer.add(descriptionGroup, forKey: "backgroundColor")
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
            apiNameLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        // DESCRIPTION NAME
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: apiNameLabel.bottomAnchor, multiplier: 1),
            descriptionLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: descriptionLabel.trailingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: descriptionLabel.bottomAnchor, multiplier: 1)
        ])
    }
}
