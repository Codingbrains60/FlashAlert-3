//
//  CustomTableViewCell.swift
//  FlashAlert
//
//  Created by Coding Brains on 22/04/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import UIKit
protocol CustomTableViewCellDelegate: AnyObject {
    func didTapCell(with title: String)
}


class CustomTableViewCell: UITableViewCell {
    weak var delegate: CustomTableViewCellDelegate?
    let titleLabel = UILabel()
        let descriptionLabel = UILabel()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            func setSelected(_ selected: Bool, animated: Bool) {
                    super.setSelected(selected, animated: animated)
                    // Configure the view for the selected state
                    if selected {
                        // Handle cell selection
                        delegate?.didTapCell(with: titleLabel.text ?? "")
                    }
                }
               
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(titleLabel)
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
            titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            
            // Configure descriptionLabel
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(descriptionLabel)
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
            descriptionLabel.font = UIFont.systemFont(ofSize: 14)
            descriptionLabel.textColor = .gray
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

