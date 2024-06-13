//
//  Model.swift
//  FlashAlert
//
//  Created by Coding Brains on 21/03/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import Foundation


struct BundleInfo {
    let name: String
    let identifier: String

    init(name: String, identifier: String) {
        self.name = name
        self.identifier = identifier
    }
}
struct ReportInfo {
    let name: String
    let fullInfo: String
    let reportEffectiveDate: String?
}
struct FlashAlert {
    let id: Int
    let effectiveDate: String
    let headline: String
    let name: String
    let urlName: String
    let url: String
}

    

struct Report {
    let name: String
    let notes: String
    let id: Int
    let effectiveDate: String
    let isValid: Bool
}
struct PressRelease {
    let id: Int
    let orgID: Int
    let headline: String
    let body: String
    let effectiveDate: String
    let orgName: String
    let thumbURL: String
    let imageURL: String
    let caption: String
}

//struct LocalNews: Codable {
//    let id: Int
//    let effectiveDate: String
//    let headline: String
//    let name: String
//    let urlName: String
//    let url: String
//}
struct LocalNews: Codable {
    let id: Int
    let effectiveDate: String
    let headline: String
    let name: String
    let urlName: String
    let url: String
}
struct LocalNewsItem {
    let id: Int
    let headline: String
    let name: String
    let url: String
    let bundleId: String 
}
//struct NewsItem {
//    let id: Int
//    let effectiveDate: String
//    let headline: String
//    let name: String
//    let urlName: String
//    let url: String
//}
struct NewItem {
    let id: Int
    let effectiveDate: String
    let headline: String
    let name: String
    let urlName: String
    let url: String
}
struct NewLocalAlerts: Codable {
    let message: String

}

struct LocalAlerts: Codable {
    let message: String
}

struct localNews: Codable {
    let id: Int
    let effectiveDate: String
    let headline: String
    let name: String
    let urlName: String
    let url: String
}


struct localAlerts: Codable {
    let message: String
}
//class DataStore {
//    static let shared = DataStore()
//    var savedNewsItems: [NewsItem] = []
//    
//    private init() {}
//}
struct ApiResponse: Codable {
    let LocalNews: [NewsItem]
}

struct NewsItem: Codable {
    let id: Int
    let effectiveDate: String
    let headline: String
    let name: String
    let urlName: String
    let url: String

}

class dataStore {
    static let shared = dataStore()
    private init() {}
    var alertItems: [AlertItem] = []
}
struct AlertItem: Codable {
    let timeZone: String
    let name: String
    let reportNotes: String
    let reportId: Int
    let reportEffectiveDate: String
    let url: String
    let message: String
}

class DataStore {
    static let shared = DataStore()
    private let userDefaultsKey = "SavedNewsItems"
    
    private init() {
        loadSavedNewsItems()
    }
    
    var savedNewsItems: [NewsItem] = []
    
    private func loadSavedNewsItems() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedItems = try? JSONDecoder().decode([NewsItem].self, from: savedData) {
            savedNewsItems = decodedItems
        }
    }
    
    func saveNewsItems(_ items: [NewsItem]) {
        savedNewsItems = items
        if let encodedData = try? JSONEncoder().encode(savedNewsItems) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }
}
