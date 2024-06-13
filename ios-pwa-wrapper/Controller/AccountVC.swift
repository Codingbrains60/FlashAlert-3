import UIKit
import SafariServices
import Alamofire
import SwiftKeychainWrapper
protocol LoginViewControllerDelegate: AnyObject {
    func didFinishLogin(withEmail email: String)
}
@available(iOS 13.0, *)
class AccountVC: UIViewController {
    
    @IBOutlet weak var newAccountBtn: UIButton!
    @IBOutlet weak var attachBtn: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailView: UIView!
    let apiUrl = "https://flashalert.projects-codingbrains.com/api/adddevice"
    let regionsUrl = "https://flashalert.projects-codingbrains.com/regions"
    let kTokenKey = "userToken"
    let kUserIDKey = "userID"
    let kUserEmailKey = "userEmail"
    let kUserPasswordKey = "userPassword"
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.text = UserDefaults.standard.string(forKey: kUserEmailKey)
        passwordTF.text = UserDefaults.standard.string(forKey: kUserPasswordKey)
        //        let backButton = UIBarButtonItem(title: "<Back", style: .plain, target: self, action: #selector(backButtonTapped))
        //        navigationItem.leftBarButtonItem = backButton
        let uniqueID = UIDevice.current.identifierForVendor!.uuidString
        print(uniqueID)
        emailView?.layer.cornerRadius = 10
        attachBtn?.layer.cornerRadius = 10
        newAccountBtn?.layer.cornerRadius = 10
        
        newAccountBtn?.addTarget(self, action: #selector(openRegionsURL), for: .touchUpInside)
    }
    //    @objc func backButtonTapped() {
    //        guard let navigationController = navigationController else {
    //            print("Navigation controller is nil")
    //            return
    //        }
    //
    //        let viewControllers = navigationController.viewControllers
    //        guard viewControllers.count >= 2 else {
    //            print("Not enough view controllers in the navigation stack")
    //            return
    //        }
    //
    //        if let segmentedViewController = viewControllers[viewControllers.count - 2] as? MyFlashVC {
    //            segmentedViewController.HandleSegmentChange(forIndex: 0) // Set the desired segment index here
    //            navigationController.popToViewController(segmentedViewController, animated: true)
    //        } else {
    //            print("The previous view controller is not of type MyFlashVC")
    //        }
    
   
    @objc func openRegionsURL() {
        if let url = URL(string: regionsUrl) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    @IBAction func neewAccountTappedBtn(_ sender: UIButton) {
        
    }
    @available(iOS 13.0, *)
    @IBAction func attachDevice(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        guard let email = emailTF.text, let password = passwordTF.text else {
            showAlert(message: "Please enter email and password")
            return
        }
        UserDefaults.standard.set(email, forKey: kUserEmailKey)
        UserDefaults.standard.set(password, forKey: kUserPasswordKey)
        
        let uniqueID = UIDevice.current.identifierForVendor!.uuidString
        let parameters: [String: Any] = [
            "EmailAddress": email,
            "NPW": password,
            "DevicePlatform": UIDevice.current.systemName,
            "DeviceName": UIDevice.current.model,
            "DeviceUUID": uniqueID,
            "DeviceVersion": UIDevice.current.systemVersion,
            "CreatedIP": "1.0.1.111"
        ]
        AF.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let value):
                    print("Response: \(value)")
                    if let valueDict = value as? [String: Any],
                       let token = valueDict["token"] as? String,
                       let userID = valueDict["userID"] as? String {
                        self.handleLoginSuccess(token: token, userID: userID)
                    }
                    self.navigateToDetachMyAccountVC(email: email)
                case .failure(let error):
                    print("Error: \(error)")
                    self.showAlert(message: "An error occurred. Please try again later.")
                }
            }
    }
    
    func handleLoginSuccess(token: String, userID: String) {
        KeychainWrapper.standard.set(token, forKey: kTokenKey)
        KeychainWrapper.standard.set(userID, forKey: kUserIDKey)
        showAlert(message: "Login successful!")
    }
    
    func navigateToDetachMyAccountVC(email: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextVC = storyboard.instantiateViewController(withIdentifier: "DetachMyAccountVc") as? DetachMyAccountVc {
            nextVC.loggedInEmail = email
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
