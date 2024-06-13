//
//  MyNewTableViewCell.swift
//  FlashAlert
//
//  Created by Coding Brains on 23/04/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import UIKit

class MyNewTableViewCell: UITableViewCell {
    

    @IBOutlet weak var shiftLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var myDateLbl: UILabel!
    @IBOutlet weak var myTitleLbl: UILabel!
    var timer: Timer?
    var mydatLbl1: String?
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
            timeFormatter.dateFormat = "hh:mm"
            let timeString = timeFormatter.string(from: Date())
            
            // Assuming you have methods to get the current shift
            let currentShift = getCurrentShift()
            
            DispatchQueue.main.async {
                self.myDateLbl.text = dateString
                self.timeLbl.text = timeString
                self.shiftLbl.text = ": \(currentShift)"
            }
        }
        
        func getCurrentShift() -> String {
            // Implement logic to get the current shift here
            // This is just a placeholder, replace it with your actual logic
            let shifts = ["AM", "PM"]
            let randomIndex = Int.random(in: 0..<shifts.count)
            return shifts[randomIndex]
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            timer?.invalidate()
            timer = nil
        }
    }
