//
//  LocalalertsVC.swift
//  FlashAlert
//
//  Created by Coding Brains on 20/03/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import UIKit
import Alamofire


@available(iOS 13.0, *)
class LocalalertsVC: UIViewController {
    
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var myTitleLbl: UILabel!
    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var localalertsTableView: UITableView!
    var refreshControl = UIRefreshControl()
    var reports: [Report] = []
    var selectedIdentifier: String?
    var receivedData: String?
    var fetchedData: String?
    var selectedData: String?
    let noDataView = UIView()
    var data: String?
    var alertName: String?
    var alertItems: [AlertItem] = []
    var bundleID: String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        if let savedData = UserDefaults.standard.data(forKey: "SavedNewsItems"),
               let savedNewsItems = try? JSONDecoder().decode([AlertItem].self, from: savedData) {
                self.alertItems = savedNewsItems
                self.localalertsTableView.reloadData()
            }
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels(_:)), name: Notification.Name("DataFetchedNotification"), object: nil)
        
        if let bundleID = bundleID {
//            fetchData(for: bundleID)
        }
    
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel(_:)), name: .menuItemSelected, object: nil)
        if let savedData = SharedStorage.shared.menuSelectedData {
            myTitleLbl.text = savedData
            bundleID = savedData
        }
        
        setupNoDataView()
        setupUI()
        setupRefreshControl()
        updateDateTime()
    }
    @objc func updateLabel(_ notification: Notification) {
        if let userInfo = notification.userInfo, let selectedItem = userInfo["bundleID"] as? String {
            UserDefaults.standard.set(selectedItem, forKey: "SelectedBundleIDViewControllerB")
            myTitleLbl.text = selectedItem
            self.bundleID = selectedItem
            MenuDataModel.shared.menuSelectedData = selectedItem
                   
                }
        
        // Timer for updating cell dates
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.localalertsTableView?.visibleCells.forEach { cell in
                if let localNewsCell = cell as? LocalAlertsTableViewCell {
                    localNewsCell.updateDateLabel(with: Date())
                    
                    
                }
            }
            
        }
    }
    @objc func updateLabels(_ notification: Notification) {
        if let userInfo = notification.userInfo, let alertItems = userInfo["newsItems"] as? [AlertItem] {
            self.alertItems = alertItems
           
            self.localalertsTableView.reloadData()
            let encodedData = try? JSONEncoder().encode(alertItems)
            UserDefaults.standard.set(encodedData, forKey: "SavedNewsItems")
        }
    }

        
        
    deinit {
            NotificationCenter.default.removeObserver(self, name: Notification.Name("DataFetchedNotification"), object: nil)
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
    func setupNoDataView() {

            noDataView.backgroundColor = .white
            let messageLabel = UILabel()
            messageLabel.text = "No emergency alerts to display."
            messageLabel.textColor = .black
            messageLabel.textAlignment = .center
            // Add messageLabel as a subview to noDataView and configure its constraints

            // Initially, hide the noDataView
            noDataView.isHidden = true
            view.addSubview(noDataView)
            // Configure constraints for noDataView
        }
 
        
    
    func setupUI() {
        localalertsTableView?.delegate = self
        localalertsTableView?.dataSource = self
        
        // Register custom section header
        //                localalertsTableView.register(CustomSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "CustomSectionHeaderView")
    }
    func updateNoDataViewVisibility() {
        if reports.isEmpty {
            hiddenView.isHidden = false
        } else {
            hiddenView.isHidden = true
        }
    }
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        localalertsTableView?.addSubview(refreshControl)
    }
    
    @objc func refreshData(_ sender: Any) {
        refreshControl.endRefreshing()

    }
    


func fetchData() {
let url = "https://flashalert.projects-codingbrains.com/api/getNewsAndReports/10"
AF.request(url).responseJSON { [weak self] response in
    guard let self = self else { return }
    switch response.result {
    case .success(let data):
        if let json = data as? [String: Any],
           let localAlerts = json["LocalAlerts"] as? [[String: Any]] {
            if localAlerts.isEmpty {
            } else {
                dataStore.shared.alertItems = localAlerts.map { alertDict in
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
                dataStore.shared.alertItems = dataStore.shared.alertItems
                self.localalertsTableView.reloadData()
                NotificationCenter.default.post(name: Notification.Name("DataFetchedNotification"), object: nil, userInfo: ["newsItems": dataStore.shared.alertItems ])
            }
        }
    case .failure(let error):
        print("Error fetching data: \(error)")
    }
    }
}
}

@available(iOS 13.0, *)
extension LocalalertsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.shared.alertItems.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = localalertsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocalAlertsTableViewCell
        
//        if let selectedData = selectedData {
//            cell.reportnotesLbl?.text = selectedData
//        } else {
        let newsItem = dataStore.shared.alertItems[indexPath.row]
            cell.NameLbl.text = newsItem.name
            cell.dateLbl.text = newsItem.reportNotes
            cell.reportnotesLbl.text = newsItem.reportEffectiveDate
           let url = newsItem.url

        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pressRelease = dataStore.shared.alertItems[indexPath.row]
        if let newsReleaseVC = storyboard?.instantiateViewController(withIdentifier: "NewsReleaseVC") as? NewsReleaseVC {
            newsReleaseVC.selectedURL = pressRelease.url
            navigationController?.pushViewController(newsReleaseVC, animated: true)
        }
        localalertsTableView.deselectRow(at: indexPath, animated: true)
    }
}
