//
//  DataBase.swift
//  FlashAlert
//
//  Created by Coding Brains on 30/05/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    private let db: Connection?

    private init() {
        do {
            // Path to the SQLite database file
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/user.db")
        } catch {
            db = nil
            print("Unable to open database: \(error)")
        }
    }

    // Function to create tables if they don't exist
    func createTables() {
        // Create your tables here
        // Example:
        // let users = Table("users")
        // let id = Expression<Int>("id")
        // let name = Expression<String>("name")
        // let email = Expression<String>("email")
        // try db?.run(users.create(ifNotExists: true) { table in
        //     table.column(id, primaryKey: true)
        //     table.column(name)
        //     table.column(email, unique: true)
        // })
    }

    // Function to insert data into tables
    func insertUser(email: String, password: String) {
        // Use the db connection to insert data into the tables
        // Example:
        // let users = Table("users")
        // let insert = users.insert(name <- "John", email <- "john@example.com")
        // do {
        //     try db?.run(insert)
        // } catch {
        //     print("Insert failed: \(error)")
        // }
    }

    // Function to retrieve data from tables
    func getUserByEmail(email: String) -> User? {
        // Use the db connection to retrieve data from the tables
        // Example:
        // let users = Table("users")
        // let query = users.filter(email == email)
        // do {
        //     let row = try db?.pluck(query)
        //     return User(id: row?[id], name: row?[name], email: row?[email])
        // } catch {
        //     print("Query failed: \(error)")
        //     return nil
        // }
        
        // Replace the above code with the following for now
        return User(id: 1, name: "John Doe", email: email)
    }

    
}
struct User {
    let id: Int
    let name: String
    let email: String
    // Add other properties as needed
}
class AlertUtils {
    static func showAlert(from viewController: UIViewController, message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
}
