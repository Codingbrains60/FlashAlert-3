//
//  NewReleaseTableViewCell.swift
//  FlashAlert
//
//  Created by Coding Brains on 12/04/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import UIKit

class NewReleaseTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var discriptionLbl: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
