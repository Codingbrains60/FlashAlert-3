
import UIKit
import Alamofire
import SafariServices
import SQLite
@available(iOS 13.0, *)
class DetachMyAccountVc: UIViewController, UINavigationControllerDelegate  {
    @IBOutlet weak var detachBtn: UIButton!
    @IBOutlet weak var managesubscriptionsBtn: UIButton!
    @IBOutlet weak var emailLbl: UILabel!
    var userEmail: String?
    let apiUrl = "https://flashalert.projects-codingbrains.com/api/detachdevice/"
    let loaderView = UIActivityIndicatorView(activityIndicatorStyle: .large)
    var loggedInEmail: String?
    var dataToShow: String = ""
    let kUserEmailKey = "UserEmailKey"
    override func viewDidLoad() {
        super.viewDidLoad()
        showStoredUserData()
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn {
            // Retrieve and display the saved email
            if let email = UserDefaults.standard.string(forKey: "loggedInEmail") {
                emailLbl.text = "Logged in as: \(email)"
            }
        } else {
            emailLbl.text = "Not logged in"
        }
        
        
        self.navigationController?.delegate = self
        let backButton = UIBarButtonItem(title: "<Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        if let email = loggedInEmail {
            emailLbl.text = "Email: \(email)"
            
            
        }
        loaderView.color = .gray
        loaderView.hidesWhenStopped = true
        let uniqueID = UIDevice.current.identifierForVendor!.uuidString
        print(uniqueID)
        managesubscriptionsBtn?.layer.cornerRadius = 10
        detachBtn?.layer.cornerRadius = 10
    }
    
    
    
    func showStoredUserData() {
        if let user = DatabaseManager.shared.getUserByEmail(email: "codingbrains62@gmail.com") {
            emailLbl.text = "Email: \(user.email ?? "")"
        }
    }
    
    @objc func backButtonTapped() {
        if let navigationController = self.navigationController {
            for viewController in navigationController.viewControllers {
                if let segmentedViewController = viewController as? MyFlashVC {
                    // Post notification to change segment
                    NotificationCenter.default.post(name: .segmentChangeNotification, object: nil, userInfo: ["segmentIndex": 0])
                    
                    // Navigate back to MyFlashVC
                    navigationController.popToViewController(segmentedViewController, animated: true)
                    return
                }
            }
            
        }
        
        
        
        func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            guard viewController == self else {
                return
            }
        }
    }
    
    @IBAction func managesubcriptionsTappedBtn(_ sender: UIButton) {
        if let url = URL(string: "https://flashalert.projects-codingbrains.com/messenger-login") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        } else {
            print("Invalid URL")
        }
    }
    @IBAction func detachtappedBtn(_ sender: UIButton) {
        let uniqueID = UIDevice.current.identifierForVendor!.uuidString
            let parameters: [String: Any] = ["DeviceUUID": uniqueID]
            let deleteUrl = apiUrl + uniqueID

            AF.request(deleteUrl, method: .delete, parameters: parameters)
                .validate()
                .responseJSON { [weak self] response in
                    guard let self = self else { return }

                    switch response.result {
                    case .success(let value):
                        print("Device deleted successfully: \(value)")
                        
                        DispatchQueue.main.async {
                            // Check if AccountVC is already in the navigation stack
                            if let accountVC = self.navigationController?.viewControllers.first(where: { $0 is AccountVC }) {
                                // AccountVC is already in the stack, pop to it
                                self.navigationController?.popToViewController(accountVC, animated: true)
                            } else {
                                // AccountVC is not in the stack, instantiate and push it
                                if let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as? AccountVC {
                                    self.navigationController?.pushViewController(accountVC, animated: true)
                                } else {
                                    // Handle the case where AccountVC could not be instantiated
                                    self.showAlert(message: "Failed to navigate to AccountVC.")
                                }
                            }
                        }
                    case .failure(let error):
                        print("Error deleting device: \(error)")
                        
                        DispatchQueue.main.async {
                            self.showAlert(message: "Failed to delete device. Please try again later.")
                        }
                    }
                }
        }

        private func showAlert(message: String) {
            let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }

}
extension Notification.Name {
    static let segmentChangeNotification = Notification.Name("segmentChangeNotification")
}
