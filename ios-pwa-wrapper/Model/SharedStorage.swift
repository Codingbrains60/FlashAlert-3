//
//  SharedStorage.swift
//  FlashAlert
//
//  Created by Coding Brains on 28/05/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

// SharedStorage.swift
import Foundation



class SharedStorage {
    static let shared = SharedStorage()
    private init() {}

    var menuSelectedData: String?
}


class MenuDataModel {
    static let shared = MenuDataModel()
    
    private init() { }
    
    var menuSelectedData: String?
    
    func saveData(data: String) {
        self.menuSelectedData = data
        // Save to UserDefaults for persistence
        UserDefaults.standard.set(data, forKey: "menuSelectedData")
    }
    
    func getData() -> String? {
        // Retrieve from UserDefaults
        return UserDefaults.standard.string(forKey: "menuSelectedData")
    }
}
