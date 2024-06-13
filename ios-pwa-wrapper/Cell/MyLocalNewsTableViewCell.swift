//
//  MyLocalNewsTableViewCell.swift
//  FlashAlert
//
//  Created by Coding Brains on 23/04/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import UIKit

class MyLocalNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var shiftLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var myDateLbl: UILabel!
    @IBOutlet weak var NewsTitleLbl: UILabel!
    var timer: Timer?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTimer()
        updateLabels()
        getCurrentShift()
    }
    func setupTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.updateLabels()
            }
        }
        
        func updateLabels() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d,"
            let dateString = dateFormatter.string(from: Date())
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            let timeString = timeFormatter.string(from: Date())
            let currentShift = getCurrentShift()
            DispatchQueue.main.async {
                self.myDateLbl.text = dateString
                self.timeLbl.text = timeString
                self.shiftLbl.text = ": \(currentShift)"
            }
        }
        
    func getCurrentShift() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        return dateFormatter.string(from: Date())
    }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            timer?.invalidate()
            timer = nil
        }
    }
