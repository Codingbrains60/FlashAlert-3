//
//  LocalNewsVC.swift
//  FlashAlert
//
//  Created by Coding Brains on 20/03/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import UIKit
import Alamofire
import MachO
@available(iOS 13.0, *)
class LocalNewsVC: UIViewController {
    
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var myTitleLbl: UILabel!
    @IBOutlet weak var localnewsTableView: UITableView!
    var flashAlerts: [FlashAlert] = []
    var statesBundles: [String: [BundleInfo]] = [:]
    var refreshControl = UIRefreshControl()
    var getNavigationController = UINavigationController()
    var selectedData: String?
    var data: Any?
    //    var NewsItems: [NewItem] = []
    var newsName: String?
    var bundleID: String?
    var menuTitle: String?
    static var bundleID: String = ""
    var newsItems: [NewsItem] = []
    
    var name: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedData()
        
        fetchData()
        
        if let savedTitle = UserDefaults.standard.string(forKey: "MyTitleLabelText") {
            // If the saved data exists, update the label and bundleID
            myTitleLbl.text = savedTitle
            bundleID = savedTitle
        } else {
            if let savedData = SharedStorage.shared.menuSelectedData {
                myTitleLbl.text = savedData
                bundleID = savedData
                UserDefaults.standard.set(savedData, forKey: "MyTitleLabelText")
            }
        }

        // Save the data to UserDefaults whenever it's updated
        if let savedData = SharedStorage.shared.menuSelectedData {
            UserDefaults.standard.set(savedData, forKey: "MyTitleLabelText")
        }

        if let savedData = UserDefaults.standard.data(forKey: "SavedNewsItems"),
           let savedNewsItems = try? JSONDecoder().decode([NewsItem].self, from: savedData) {
            DataStore.shared.savedNewsItems = savedNewsItems
            self.localnewsTableView.reloadData()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels(_:)), name: Notification.Name("DataFetchedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel(_:)), name: .menuItemSelected, object: nil)
        // Check if the data already exists in UserDefaults
        if let savedTitle = UserDefaults.standard.string(forKey: "MyTitleLabelText") {
            if let savedData = SharedStorage.shared.menuSelectedData {
                myTitleLbl.text = savedData
                bundleID = savedData
            } else {
                // If the data doesn't exist, set it and save it in UserDefaults
                if let savedData = SharedStorage.shared.menuSelectedData {
                    myTitleLbl.text = savedData
                    bundleID = savedData
                    UserDefaults.standard.set(savedData, forKey: "MyTitleLabelText")
                }
            }
        }
        
        localnewsTableView.delegate = self
        localnewsTableView.dataSource = self
        if let bundleID = bundleID {
        }
        updateDateTime()
        
    }
    func loadSavedData() {
        if let saveData = UserDefaults.standard.data(forKey: "SavedNewsItems"),
           let decodeItems = try? JSONDecoder().decode([NewsItem].self, from: saveData) {
            //            savedNewsItems = decodeItems
        }
        localnewsTableView.reloadData()
    }
    
    @objc func updateLabel(_ notification: Notification) {
        if let userInfo = notification.userInfo, let selectedItem = userInfo["bundleID"] as? String {
            UserDefaults.standard.set(selectedItem, forKey: "SelectedBundleIDViewControllerB")
            myTitleLbl.text = selectedItem
            bundleID = selectedItem
            MenuDataModel.shared.menuSelectedData = selectedItem
            guard let userInfo = notification.userInfo,
                  let selectedItem = userInfo["bundleID"] as? String else {
                return
            }
                
                UserDefaults.standard.set(selectedItem, forKey: "MyTitleLabelText")
                print("Saved title text: \(selectedItem)")
            }
            
            
        }
    
    
    @objc func updateLabels(_ notification: Notification) {
        if let userInfo = notification.userInfo, let newsItems = userInfo["newsItems"] as? [NewsItem] {
            // Update the data store with fetched news items
            DataStore.shared.savedNewsItems = newsItems
            self.localnewsTableView.reloadData()
            
            // Save the fetched news items to UserDefaults
            saveData(newsItems: newsItems)
        }
    }
    
    func saveData(newsItems: [NewsItem]) {
        // Encode news items to Data
        if let encodedData = try? JSONEncoder().encode(newsItems) {
            // Save encoded data to UserDefaults
            UserDefaults.standard.set(encodedData, forKey: "SavedNewsItems")
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check if the data already exists in UserDefaults
        if let savedData = UserDefaults.standard.data(forKey: "SavedNewsItems"),
               let savedNewsItems = try? JSONDecoder().decode([NewsItem].self, from: savedData) {
                // Update the data store with saved news items if not already loaded
                if DataStore.shared.savedNewsItems.isEmpty {
                    DataStore.shared.savedNewsItems = savedNewsItems
                    self.localnewsTableView.reloadData()
                }
            }
            
            // Fetch new data only if it's not already loaded
            if DataStore.shared.savedNewsItems.isEmpty {
                fetchData()
            }
        
    }

        deinit {
            NotificationCenter.default.removeObserver(self, name: Notification.Name("DataFetchedNotification"), object: nil)
            NotificationCenter.default.removeObserver(self, name: .menuItemSelected, object: nil)
        }
    
    func fetchData() {
            let url = "https://flashalert.projects-codingbrains.com/api/getNewsAndReports/10"
            
            AF.request(url).responseDecodable(of: ApiResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let apiResponse):
                    if apiResponse.LocalNews.isEmpty {
                        self.handleNoData()
                    } else {
                        // Save the fetched news items to UserDefaults
                        self.saveNewsItemsToUserDefaults(apiResponse.LocalNews)
                        
                        // Reload table view with fetched news items
                        self.noDataLabel.isHidden = true
                        self.localnewsTableView.reloadData()
                        
                        // Post notification to indicate that new data is fetched
                        NotificationCenter.default.post(name: Notification.Name("DataFetchedNotification"), object: nil, userInfo: ["newsItems": apiResponse.LocalNews])
                    }
                case .failure(let error):
                    print("Error fetching data: \(error)")
                    self.handleNoData()
                }
            }
        }

        func saveNewsItemsToUserDefaults(_ newsItems: [NewsItem]) {
            // Encode news items to Data
            if let encodedData = try? JSONEncoder().encode(newsItems) {
                // Save encoded data to UserDefaults
                UserDefaults.standard.set(encodedData, forKey: "SavedNewsItems")
            }
        }

        

        
        func handleNoData() {
            self.noDataLabel.isHidden = true
            self.noDataLabel.text = "No reports found for this region"
            self.localnewsTableView.reloadData()
        }
    }



    @available(iOS 13.0, *)
    extension LocalNewsVC: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return DataStore.shared.savedNewsItems.count
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = localnewsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocalNewsTableViewCell
            let newsItem = DataStore.shared.savedNewsItems[indexPath.row]
            cell.nameLbl.text = newsItem.name
            cell.discriptionLbl.text = newsItem.headline
            cell.localdate.text = newsItem.effectiveDate
            // Assuming there is an image view to load the image from URL, using a library like SDWebImage is recommended
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let newsItem = DataStore.shared.savedNewsItems[indexPath.row]
            if let newsReleaseVC = storyboard?.instantiateViewController(withIdentifier: "NewsReleaseVC") as? NewsReleaseVC {
                newsReleaseVC.selectedURL = newsItem.url
                navigationController?.pushViewController(newsReleaseVC, animated: true)
            }
            localnewsTableView.deselectRow(at: indexPath, animated: true)
        }
    }
