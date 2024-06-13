//
//  UserDefaultsManager.swift
//  FlashAlert
//
//  Created by Coding Brains on 24/04/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    func setUserLoggedIn(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "isLoggedIn")
    }
    
    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}

