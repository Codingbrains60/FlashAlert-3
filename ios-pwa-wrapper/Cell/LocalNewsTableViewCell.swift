//
//  LocalNewsTableViewCell.swift
//  FlashAlert
//
//  Created by Coding Brains on 20/03/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import UIKit

class LocalNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var localdate: UILabel!
    @IBOutlet weak var discriptionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    func updateDateLabel(with date: Date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd/ h:mm a"
            let formattedDate = dateFormatter.string(from: date)
            
        localdate.text = formattedDate
        }
    }


