//
//  SortMenuTableViewCell.swift
//  upwards-ios-challenge
//
//  Created by Ryan Helgeson on 11/2/23.
//

import UIKit

class SortMenuTableViewCell: UITableViewCell {
    
    let sortLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        sortLabel.translatesAutoresizingMaskIntoConstraints = false
        sortLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        sortLabel.textColor = .darkGray
        self.contentView.backgroundColor = .white
        
        contentView.addSubview(sortLabel)
        
        NSLayoutConstraint.activate([
            // Container View
            sortLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sortLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sortLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            sortLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        ])
    }
}
