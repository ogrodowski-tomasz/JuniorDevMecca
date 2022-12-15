//
//  HomeTableHeaderView.swift
//  PublicApis
//
//  Created by Tomasz Ogrodowski on 15/12/2022.
//

import Foundation
import UIKit

class HomeTableHeaderView: UIView {
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 144)
    }
}

extension HomeTableHeaderView {
    private func setup() {
        titleLabel.text = "Public APIs"
        titleLabel.font = .futuraFont(ofSize: 30)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel.text = "Some public API for Your new portfolio project..."
        subtitleLabel.font = .futuraFont(ofSize: 20)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelsStack.spacing = 5
        labelsStack.axis = .vertical
        labelsStack.alignment = .center
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(labelsStack)
        
        NSLayoutConstraint.activate([
            labelsStack.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: labelsStack.trailingAnchor, multiplier: 1),
            labelsStack.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: labelsStack.bottomAnchor, multiplier: 2)
        ])
    }
}
