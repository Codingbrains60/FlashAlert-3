//
//  AppDelegate.swift
//  ios-pwa-wrapper
//
//  Created by Martin Kainzbauer on 25/10/2017.
//  Copyright © 2017 Martin Kainzbauer. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import SwiftKeychainWrapper

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        if accessToken != nil
        {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "main", bundle: nil)
            let homepage = mainStoryboard.instantiateViewController(withIdentifier: "DetachMyAccountVc") as! DetachMyAccountVc
            self.window?.rootViewController = homepage
        }
        // Change Navigation style
        UINavigationBar.appearance().barTintColor = navigationBarColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: navigationTitleColor]
        UIBarButtonItem.appearance().tintColor = navigationButtonColor
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: navigationTitleColor]
        }
        
        
        return true
        let isLoggedIn = checkUserLoginStatus()

                // Set initial view controller based on login status
                if isLoggedIn {
                    showHomeScreen()
                } else {
                    showLoginScreen()
                }

                return true
            }

            func checkUserLoginStatus() -> Bool {
                // Implement your user login status check logic here
                // For example, check if user is logged in or not
                // Return true if user is logged in, false otherwise
                return false
            }

            func showHomeScreen() {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeVC = storyboard.instantiateViewController(withIdentifier: "MyDataVC")
                window?.rootViewController = homeVC
                window?.makeKeyAndVisible()
            }

            func showLoginScreen() {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "RegisterVC")
                window?.rootViewController = loginVC
                window?.makeKeyAndVisible()
            }

            // Your other code

        }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
@available(iOS 13.0, *)
func applicationWillTerminate(_ application: UIApplication) {
    
        
        // If you want to access the root view controller to retrieve some data before termination
        
            if let window = UIApplication.shared.windows.first {
                if let viewController = window.rootViewController as? LocalNewsVC {
                    let bundleID = LocalNewsVC.bundleID // Accessing static propertylet savedData = LocalNewsVC.bundleID
                    UserDefaults.standard.set(bundleID, forKey: "BundleID")
                    UserDefaults.standard.set(bundleID, forKey: "SavedNewsItems")
                }
            }
        }
