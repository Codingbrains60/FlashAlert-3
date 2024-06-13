 

import UIKit
import SideMenu
import Alamofire


extension Notification.Name {
    static let sideMenuItemClicked = Notification.Name("SideMenuItemClicked")
}

protocol DataPassingDelegate: AnyObject {
    func passData(_ data: String)
}
@available(iOS 13.0, *)
class MyFlashVC: UIViewController {
    weak var delegate: DataPassingDelegate?
    var menu: SideMenuNavigationController?
    @IBOutlet weak var myContainerview: UIView!
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    private var sideMenu: SideMenuNavigationController?
    var alertController: UIAlertController?
    var myDataVC: MyDataVC?
    var loggedIn: Bool = false
    var isLoggedIn: Bool = false
    private var activityIndicator: UIActivityIndicatorView!
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    var data: String?
    var bundleInfo: Bundle?
    
    let segmentControl = UISegmentedControl(items: ["My FlashAlerts", "Local Alerts", "News Alerts"])
    let bundleName = "YourBundleName"
    let bundleIdentifier = "YourBundleIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSegmentChangeNotification(_:)), name: .segmentChangeNotification, object: nil)
        
        segmentControl.addTarget(self, action: #selector(HandleSegmentChange), for: .valueChanged)
        let bundleInfo = BundleInfo(name: bundleName, identifier: bundleIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(HandleNotification(_:)), name: .myNotification, object: nil)
        
        isLoggedIn = true
        menu = SideMenuNavigationController(rootViewController: MenuController())
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        segmentControl.layer.borderWidth = 1.0
        segmentControl.layer.borderColor =   #colorLiteral(red: 0.1864822458, green: 0.635185874, blue: 1, alpha: 1)
        segmentControl.layer.cornerRadius = 5
        segmentControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:   #colorLiteral(red: 0.1864822458, green: 0.635185874, blue: 1, alpha: 1)], for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentControl.selectedSegmentTintColor = UIColor(red: 0, green: 0.46, blue: 0.89, alpha: 1)
        view.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        updateToMyDataVC()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sideMenuBtn?.isEnabled = false
        sideMenuBtn?.tintColor = UIColor.clear
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        addChildViewController(vc)
        myContainerview.addSubview(vc.view)
        vc.view.frame = myContainerview.bounds
        navigationItem.title = "My FlashAlerts"
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1864822458, green: 0.635185874, blue: 1, alpha: 1)], for: .normal)
    }
    @objc func handleSegmentChangeNotification(_ notification: Notification) {
        if let index = notification.userInfo?["segmentIndex"] as? Int {
            HandleSegmentChange(forIndex: index)
            sideMenuBtn?.isEnabled = false
            sideMenuBtn?.tintColor = .clear

            // Hide the RegisterVC by removing it from the view hierarchy
            for childVC in childViewControllers {
                if childVC is RegisterVC {
                    childVC.view.removeFromSuperview()
                    childVC.removeFromParentViewController()
                }
            }

            let vc = storyboard?.instantiateViewController(withIdentifier: "MyDataVC") as! MyDataVC
            addChildViewController(vc)
            myContainerview.subviews.forEach { $0.removeFromSuperview() }
            myContainerview.addSubview(vc.view)
            vc.view.frame = myContainerview.bounds
            navigationItem.title = "My FlashAlerts"
            let backButton = UIBarButtonItem()
            backButton.title = "Back"
            navigationItem.backBarButtonItem = backButton
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1864822458, green: 0.635185874, blue: 1, alpha: 1)], for: .normal)
        }
    }

        
    @objc func SHandleSegmentChange(forIndex index: Int) {
            self.segmentControl.selectedSegmentIndex = index
           
        }
        
        
    
    
    func postNotificationWithData() {
            let userInfo: [String: Any] = [
                "menuTitle": "Local Alerts" // Example data
            ]
            NotificationCenter.default.post(name: .sideMenuItemClicked, object: nil, userInfo: userInfo)
        }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRegisterScreen()
        NotificationCenter.default.addObserver(self, selector: #selector(handleBackButtonPressed(_:)), name: Notification.Name("BackButtonPressed"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // Remove observer when the view disappears
            NotificationCenter.default.removeObserver(self, name: Notification.Name("BackButtonPressed"), object: nil)
        }
    @objc func handleBackButtonPressed(_ notification: Notification) {
            print("Switching to the first screen")
        }
    func updateRegisterScreen() {
    }
    private func addChildController() {
    }
    @objc func updateUI() {
    }
    @available(iOS 13.0, *)
    @IBAction func lodertappedBtn(_ sender: UIBarButtonItem) {
        let customLoaderView = CustomLoaderView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController?.view.subviews.forEach({ $0.removeFromSuperview() })
        alertController?.view.addSubview(customLoaderView)
        customLoaderView.centerXAnchor.constraint(equalTo: alertController!.view.centerXAnchor).isActive = true
        customLoaderView.centerYAnchor.constraint(equalTo: alertController!.view.centerYAnchor).isActive = true
        self.present(alertController!, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.stopLoadingAlerts()
        }
    }
    func stopLoadingAlerts() {
        alertController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func didTappedMenu(){
        presentSideMenu()
    }
    func presentSideMenu() {
        if let sideMenu = menu {
            present(sideMenu, animated: true, completion: nil)
        } else {
            print("Side Menu is not initialized.")
        }
    }
    func updateToRegisterVC() {
        
    }
    func updateToMyDataVC() {
        
    }
    @objc func backButtonPressed() {
        if loggedIn {
            updateToMyDataVC()
        } else {
            
        }
    }
    @objc func myhandleNotification(_ notification: Notification) {
        let loaderView = LoaderView()
            loaderView.show(in: self.view, withMessage: "Local Alerts Loading")
        if let userInfo = notification.userInfo {
            if let bundleID = userInfo["bundleID"] as? String, let name = userInfo["name"] as? String {
                let vc = storyboard?.instantiateViewController(withIdentifier: "MyNewVC") as! MyNewVC
                vc.bundleID = bundleID
                vc.name = name
                print("Received bundle identifier: \(bundleIdentifier)")
                addChildViewController(vc)
                myContainerview.subviews.forEach { $0.removeFromSuperview() }
                myContainerview.addSubview(vc.view)
                vc.view.frame = myContainerview.bounds
                navigationItem.title = "My FlashAlerts"
                let backButton = UIBarButtonItem()
                backButton.title = "Back"
                navigationItem.backBarButtonItem = backButton
                if let bundleInfo = notification.userInfo?["bundleInfo"] as? Bundle,
                   bundleID == bundleInfo.bundleIdentifier {
                    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1864822458, green: 0.635185874, blue: 1, alpha: 1)], for: .normal)
                }
                loaderView.hide()
            }
        }
    }
    @objc func HandleNotification(_ notification: Notification) {
        let loaderView = LoaderView()
            loaderView.show(in: self.view, withMessage: "Local Alerts Loading")
        if let userInfo = notification.userInfo {
                if let bundleID = userInfo["bundleID"] as? String, let name = userInfo["name"] as? String {
                let vc = storyboard?.instantiateViewController(withIdentifier: "MyNewAlertsVC") as! MyNewAlertsVC
                vc.bundleID = bundleID
                vc.name = name
                print("Received bundle identifier: \(bundleIdentifier)")
                
                addChildViewController(vc)
                myContainerview.subviews.forEach { $0.removeFromSuperview() }
                myContainerview.addSubview(vc.view)
                vc.view.frame = myContainerview.bounds
                navigationItem.title = "My FlashAlerts"
                let backButton = UIBarButtonItem()
                backButton.title = "Back"
                navigationItem.backBarButtonItem = backButton
                if let bundleInfo = notification.userInfo?["bundleInfo"] as? Bundle,
                   bundleID == bundleInfo.bundleIdentifier {
                    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1864822458, green: 0.635185874, blue: 1, alpha: 1)], for: .normal)
                }
                    loaderView.hide()
            }
        }
        
    }
    @objc fileprivate func handleSegmentChange() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            
                    sideMenuBtn?.isEnabled = false
                    sideMenuBtn?.tintColor = .clear
                    let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
                    addChildViewController(vc)
                    myContainerview.subviews.forEach { $0.removeFromSuperview() }
                    myContainerview.addSubview(vc.view)
                    vc.view.frame = myContainerview.bounds
                    navigationItem.title = "My FlashAlerts"
                    let backButton = UIBarButtonItem()
                    backButton.title = "Back"
                    navigationItem.backBarButtonItem = backButton
                    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1864822458, green: 0.635185874, blue: 1, alpha: 1)], for: .normal)
                
        case 1:
            
            sideMenuBtn?.tintColor = nil
            sideMenuBtn?.isEnabled = true
            let vc = storyboard?.instantiateViewController(withIdentifier: "LocalalertsVC") as! LocalalertsVC
            vc.alertName = bundleName
            addChildViewController(vc)
            myContainerview.subviews.forEach { $0.removeFromSuperview() }
            myContainerview.addSubview(vc.view)
            vc.view.frame = myContainerview.bounds
            navigationItem.title = "Local Alerts"
            let backButton = UIBarButtonItem()
            backButton.title = "Back"
            navigationItem.backBarButtonItem = backButton
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1864822458, green: 0.635185874, blue: 1, alpha: 1)], for: .normal)
            NotificationCenter.default.addObserver(self, selector: #selector(myhandleNotification), name: .myNotification, object: nil)
        case 2:
            sideMenuBtn?.tintColor = nil
            sideMenuBtn?.isEnabled = true
            myContainerview.subviews.forEach { $0.removeFromSuperview() }
            let vc = storyboard?.instantiateViewController(withIdentifier: "LocalNewsVC") as! LocalNewsVC
            vc.newsName = bundleName
            vc.myTitleLbl?.text = bundleName
            addChildViewController(vc)
            myContainerview.addSubview(vc.view)
            vc.view.frame = myContainerview.bounds
            navigationItem.title = "Local News"
            let backButton = UIBarButtonItem()
            backButton.title = "Back"
            navigationItem.backBarButtonItem = backButton
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1864822458, green: 0.635185874, blue: 1, alpha: 1)], for: .normal)
            NotificationCenter.default.addObserver(self, selector: #selector(HandleNotification), name: .myNotification, object: nil)
            
        default:
            break
        }
    }
    @objc func HandleSegmentChange(forIndex index: Int) {
            segmentControl.selectedSegmentIndex = index
            handleSegmentChange()
        }
    
}
@available(iOS 13.0, *)
extension MyFlashVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.segmentControl.selectedSegmentIndex {
        case 0:
            let localNewsVC = MyNewVC()
            localNewsVC.selectedData = "Data for Row \(indexPath.row)"
            navigationController?.pushViewController(localNewsVC, animated: true)
        case 1:
            let localalertsVC = LocalalertsVC()
            localalertsVC.selectedData = "Data for Row \(indexPath.row)"
            navigationController?.pushViewController(localalertsVC, animated: true)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
@available(iOS 13.0, *)
protocol SideMenuDelegate: AnyObject {
    func didSelectItem(_ item: String)
}
@available(iOS 13.0, *)
class MenuController: UITableViewController{
    private var statesBundles: [String: [BundleInfo]] = [:]
    var bundleInfos: [BundleInfo] = []
    var indexTitles: [String] = []
    var sideMenuBtn: UIButton!
    var myContainerview: UIView!
    var myflashalertLbl: UILabel!
    var selectedData: String?
    private var loaderView: LoaderView!
    weak var delegate: SideMenuDelegate?
    func handleSelection(_ item: String) {
            delegate?.didSelectItem(item)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loaderView = LoaderView()
                
        NotificationCenter.default.addObserver(self, selector: #selector(handleMenuItemSelected(_:)), name: Notification.Name("MenuItemSelected"), object: nil)
        tableView.backgroundColor = .white
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "customCell") // Register CustomTableViewCell
        let headerView = SideMenuHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        tableView.tableHeaderView = headerView
        fetchData()
    }
    @objc func handleMenuItemSelected(_ notification: Notification) {
            if let selectedData = notification.object as? String {
                loaderView.show(in: self.view, withMessage: "Local Alerts Loading")  // Show loader
                switch selectedData {
                case "Local News":
                    let localNewsVC = LocalNewsVC()
                    localNewsVC.selectedData = "Data for Local News"
                    navigationController?.pushViewController(localNewsVC, animated: true)
                case "Some Other Screen":
                    let otherVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocalNewsVC") as! LocalNewsVC
                    navigationController?.pushViewController(otherVC, animated: true)
                default:
                    let otherVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocalNewsVC") as! LocalNewsVC
                    navigationController?.pushViewController(otherVC, animated: true)
                    break
                }
                self.loaderView.hide()
            }
        }
    
    private func fetchData() {
        AF.request("https://flashalert.projects-codingbrains.com/api/index").responseJSON { response in
            switch response.result {
            case .success(let value):
                if let jsonArray = value as? [[String: Any]] {
                    self.parseData(jsonArray: jsonArray)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func parseData(jsonArray: [[String: Any]]) {
        for item in jsonArray {
            if let state = item["State"] as? String,
               let bundleName = item["DescriptionBundle"] as? String,
               let bundleId = item["BundleId"] as? String {
                let newBundle = BundleInfo(name: bundleName, identifier: bundleId)
                self.statesBundles[state, default: []].append(newBundle)
            }
        }
        indexTitles = statesBundles.keys.sorted()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return indexTitles.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let state = indexTitles[section]
        return statesBundles[state]?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        header.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indexTitles[section]
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 37
    }
    func heightForText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        let state = indexTitles[indexPath.section]
        if let bundleInfo = statesBundles[state]?[indexPath.row] {
            cell.titleLabel.text =  bundleInfo.name
            cell.descriptionLabel.text =   bundleInfo.identifier
            let bundleID =  bundleInfo.identifier
            cell.titleLabel.textColor = .black
            cell.descriptionLabel.textColor = .white
            cell.descriptionLabel.backgroundColor = .white
            cell.titleLabel.backgroundColor = .white
            cell.backgroundColor = .white
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bundleInfo = self.statesBundles[indexTitles[indexPath.section]]?[indexPath.row] {
            loaderView.show(in: self.view, withMessage: "Local Alerts Loading")
            SelectedBundleIDManager.shared.selectedBundleID = bundleInfo.identifier
            
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyNewAlertsVC") as! MyNewAlertsVC
            print("Selected Item: \(bundleInfo)")
            vc.name =  bundleInfo.identifier
            print("Received bundleInfo: \(bundleInfo)")
            vc.bundleID = bundleInfo.identifier
            let userInfo: [String: Any] = ["bundleID": bundleInfo.identifier, "name": bundleInfo.name]
            SharedStorage.shared.menuSelectedData = bundleInfo.name + bundleInfo.identifier
                    NotificationCenter.default.post(name: Notification.Name("MyNotification"), object: nil, userInfo: userInfo)
            self.dismiss(animated: true)
            self.loaderView.hide()
            
        }
    }

    
}
extension Notification.Name {
    static let myNotification = Notification.Name("MyNotification")
    static let menuItemSelected = Notification.Name("MenuItemSelected")
}

    

class SelectedBundleIDManager {
    static let shared = SelectedBundleIDManager()
    var selectedBundleID: String?
    
    private init() {}
}
