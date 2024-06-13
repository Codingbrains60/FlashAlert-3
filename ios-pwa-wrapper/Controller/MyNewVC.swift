//
//  MyNewVC.swift
//  FlashAlert
//
//  Created by Coding Brains on 02/05/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import UIKit
import Alamofire
class MyNewVC: UIViewController {
    var selectedData: String?
    var data: Any?
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var myTitleLbl: UILabel!
    @IBOutlet weak var myNewTableView: UITableView!
    var flashAlerts: [FlashAlert] = []
    var statesBundles: [String: [BundleInfo]] = [:]
    var refreshControl = UIRefreshControl()
    var getNavigationController = UINavigationController()
    var newsItems: [NewsItem] = []
    var alertItems: [AlertItem] = []
    var name = ""
    var bundleID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDateTime()
        myTitleLbl.text = name
        myNewTableView.delegate = self
        myNewTableView.dataSource = self
        myNewTableView.addSubview(refreshControl)
        setupRefreshControl()
        fetchData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel(_:)), name: .menuItemSelected, object: nil)
        if let savedData = SharedStorage.shared.menuSelectedData {
            myTitleLbl.text = savedData
            bundleID = savedData
        }
    }
    @objc func handleNotification(_ notification: Notification) {
    }
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        myNewTableView?.addSubview(refreshControl)
    }
    @objc func updateLabel(_ notification: Notification) {
        if let userInfo = notification.userInfo, let selectedItem = userInfo["bundleID"] as? String {
            UserDefaults.standard.set(selectedItem, forKey: "SelectedBundleIDViewControllerA") // Unique key for bundle identifier
               myTitleLbl.text = selectedItem
               bundleID = selectedItem
        }
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
    @objc func refreshData(_ sender: Any) {
        refreshControl.endRefreshing()
        fetchData()
    }
    func fetchData() {
    print("Selected Item: \(bundleID)")
    let url = "https://flashalert.projects-codingbrains.com/api/getNewsAndReports/\(bundleID)"
    AF.request(url).responseJSON { [weak self] response in
        guard let self = self else { return }
        switch response.result {
        case .success(let data):
            if let json = data as? [String: Any],
               let localAlerts = json["LocalAlerts"] as? [[String: Any]] {
                if localAlerts.isEmpty {
                self.noDataLabel.isHidden = false
                self.noDataLabel.text = "No reports found for this region."
                } else {
                    self.noDataLabel.isHidden = true
                    self.alertItems = localAlerts.map { alertDict in
                        return AlertItem(
                            timeZone: alertDict["TimeZone"] as? String ?? "",
                            name: alertDict["Name"] as? String ?? "",
                            reportNotes: alertDict["report_notes"] as? String ?? "",
                            reportId: alertDict["report_id"] as? Int ?? 0,
                            reportEffectiveDate: alertDict["report_effective_date"] as? String ?? "",
                            url: url,
                            message: "No reports found for this region."
                        )
                    }
                    dataStore.shared.alertItems = self.alertItems
                    self.myNewTableView.reloadData()
                    NotificationCenter.default.post(name: Notification.Name("DataFetchedNotification"), object: nil, userInfo: ["newsItems": self.alertItems])
                }
            }
        case .failure(let error):
            print("Error fetching data: \(error)")
        }
        }
    }
}
extension MyNewVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myNewTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewTableViewCell
        let alertItem = alertItems[indexPath.row]
            cell.nameLbl.text = alertItem.name
        cell.myDiscriptionLbl.text = alertItem.reportNotes
        cell.datrLbl.text = alertItem.reportEffectiveDate
        let url = alertItem.url
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pressRelease = alertItems[indexPath.row]
        if let newsReleaseVC = storyboard?.instantiateViewController(withIdentifier: "NewsReleaseVC") as? NewsReleaseVC {
            newsReleaseVC.selectedURL = pressRelease.url
            navigationController?.pushViewController(newsReleaseVC, animated: true)
        }
        myNewTableView.deselectRow(at: indexPath, animated: true)
    }
}



