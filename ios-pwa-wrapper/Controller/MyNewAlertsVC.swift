//
//  MyNewAlertsVC.swift
//  FlashAlert
//
//  Created by Coding Brains on 08/05/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import UIKit
import Alamofire
class MyNewAlertsVC: UIViewController {
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var alertsTitleLbl: UILabel!
    @IBOutlet weak var myNewAlertsTableview: UITableView!
    var refreshControl = UIRefreshControl()
    var flashAlerts: [FlashAlert] = []
    var statesBundles: [String: [BundleInfo]] = [:]
    var getNavigationController = UINavigationController()
    var newsItems: [NewsItem] = []
    var name = ""
    var bundleID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        updateDateTime()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel(_:)), name: .menuItemSelected, object: nil)
        if let savedData = SharedStorage.shared.menuSelectedData {
            alertsTitleLbl.text = savedData
            bundleID = savedData
        }
        myNewAlertsTableview.delegate = self
        myNewAlertsTableview.dataSource = self
        setupRefreshControl()
        print("Received bundleID in MyNewAlertsVC: \(bundleID)")
        NotificationCenter.default.addObserver(self, selector: #selector(HandleNotification(_:)), name: .myNotification, object: nil)
    }
    
    @objc func updateLabel(_ notification: Notification) {
        if let userInfo = notification.userInfo, let selectedItem = userInfo["bundleID"] as? String {
            UserDefaults.standard.set(selectedItem, forKey: "SelectedBundleIDViewControllerA") // Unique key for bundle identifier
            alertsTitleLbl.text = selectedItem
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
    @objc func HandleNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let identifier = userInfo["identifier"] as? String {
            bundleID = identifier
            print("Selected Item: \(bundleID)")
        }
        func updateTitleLabel(with text: String) {
            alertsTitleLbl.text = text
        }
    }
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        myNewAlertsTableview.addSubview(refreshControl)
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
                   let localNewsJSON = json["LocalNews"] as? [[String: Any]] {
                    self.noDataLabel.isHidden = true
                    self.noDataLabel.text = "No reports found for this region."
                    self.newsItems = localNewsJSON.compactMap { dict in
                        guard let id = dict["id"] as? Int,
                              let effectiveDate = dict["EffectiveDate"] as? String,
                              let headline = dict["Headline"] as? String,
                              let name = dict["Name"] as? String,
                              let urlName = dict["URLName"] as? String,
                              let url = dict["url"] as? String else {
                            return nil
                        }
                        return NewsItem(id: id, effectiveDate: effectiveDate, headline: headline, name: name, urlName: urlName, url: url)
                    }
                    if let encodeData = try? JSONEncoder().encode(self.newsItems) {
                        UserDefaults.standard.set(encodeData, forKey: "SavedNewsItems")
                    }
                    
                    self.myNewAlertsTableview.reloadData()
                    
                    NotificationCenter.default.post(name: Notification.Name("DataFetchedNotification"), object: nil, userInfo: ["newsItems": self.newsItems])
                    
                } else {
                    self.handleNoData()
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
                UserDefaults.standard.set("Error fetching data: \(error)", forKey: "DataFetchStatus")
                self.handleNoData()
            }
        }
    }
    
    func handleNoData() {
        self.noDataLabel.isHidden = false
        self.noDataLabel.text = "No reports found for this region"
        UserDefaults.standard.set(Data(), forKey: "SavedNewsItems")
    }
}
    extension MyNewAlertsVC: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return newsItems.isEmpty ? 1 : newsItems.count
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = myNewAlertsTableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyNewLocalNewsTableViewCell
            if newsItems.isEmpty {
                cell.myNameLbl.text = "No reports found for this region"
                cell.myDiscriptionLbl.text = ""
                cell.mydateLbl.text = ""
            } else {
                let newsItem = newsItems[indexPath.row]
                cell.myNameLbl.text = newsItem.name
                cell.myDiscriptionLbl.text = newsItem.headline
                cell.mydateLbl.text = newsItem.effectiveDate
                let url = newsItem.url
            }

            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let pressRelease = newsItems[indexPath.row]
            if let newsReleaseVC = storyboard?.instantiateViewController(withIdentifier: "NewsReleaseVC") as? NewsReleaseVC {
                newsReleaseVC.selectedURL = pressRelease.url
                navigationController?.pushViewController(newsReleaseVC, animated: true)
            }
            myNewAlertsTableview.deselectRow(at: indexPath, animated: true)
        }
    }

