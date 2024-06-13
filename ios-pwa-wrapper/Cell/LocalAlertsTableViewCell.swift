//
//  LocalAlertsTableViewCell.swift
//  FlashAlert
//
//  Created by Coding Brains on 09/04/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import UIKit

class LocalAlertsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var reportnotesLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        
    }
    func updateDateLabel(with date: Date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd/ h:mm a"
            let formattedDate = dateFormatter.string(from: date)
            
        dateLbl.text = formattedDate
        }
    
}
