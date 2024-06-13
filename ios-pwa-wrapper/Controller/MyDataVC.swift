//
//  MyDataVC.swift
//  FlashAlert
//
//  Created by Coding Brains on 03/04/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import UIKit
import Alamofire

class MyDataVC: UIViewController {
    
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var mydataTableView: UITableView!
    
    @IBOutlet weak var accountsettingBtn: UIButton!
    var reports: [ReportInfo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mydataTableView?.delegate = self
        mydataTableView?.dataSource = self
        fetchData()
        updateDateTime()
        accountsettingBtn?.layer.cornerRadius = 10
        if let userEmail = UserDefaults.standard.string(forKey: "userEmail"),
               let userPassword = UserDefaults.standard.string(forKey: "userPassword") {
                print("User Email: \(userEmail), User Password: \(userPassword)")
            
        }
        func updateDateTime() {
                let currentDate = Date()  
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = " hh:mm a, E,MMM dd"
                let formattedDateTime = dateFormatter.string(from: currentDate)
                let currentHour = Calendar.current.component(.hour, from: currentDate)
                let shift = currentHour < 12 ? "AM" : "PM"
                monthLbl.text = "\(formattedDateTime)"
            }
    }
    @available(iOS 13.0, *)
    @IBAction func sccountsettingTappedBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               if let detachVC = storyboard.instantiateViewController(withIdentifier: "DetachMyAccountVc") as? DetachMyAccountVc {
                   self.navigationController?.pushViewController(detachVC, animated: true)
               }

            }

    
    func fetchData() {
        AF.request("https://flashalert.projects-codingbrains.com/api/subscription/A7056BC5-8644-4297-AFCE-924753AA546D").responseJSON { response in
            switch response.result {
            case .success(let value):
                if let jsonArray = value as? [[String: Any]] {
                    self.reports = jsonArray.compactMap { dictionary in
                        guard let name = dictionary["Name"] as? String,
                              let reportInfoDict = dictionary["reportInfo"] as? [String: Any],
                              let fullInfo = reportInfoDict["full_info"] as? String else {
                            return nil
                        }
                        let reportEffectiveDate = reportInfoDict["report_effective_date"] as? String
                        
                        return ReportInfo(name: name, fullInfo: fullInfo, reportEffectiveDate: reportEffectiveDate)
                    }
                    
                    DispatchQueue.main.async {
                        self.mydataTableView?.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension MyDataVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mydataTableView?.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyDataTableViewCell
        let report = reports[indexPath.row]
                cell.mydatLbl.text = report.name
                cell.mydiscriptionLbl.text = report.fullInfo
        
        cell.dateLbl.text = report.reportEffectiveDate
                return cell
    }
    
    
}
