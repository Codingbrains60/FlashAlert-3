//
//  LocalNewsData.swift
//  FlashAlert
//
//  Created by Coding Brains on 09/05/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import Foundation

struct NewLocalNews {
    let id: Int
    let effectiveDate: String
    let headline: String
    let name: String
    let urlName: String
    let url: String
    enum CodingKeys: String, CodingKey {
            case id, effectiveDate = "EffectiveDate", headline = "Headline", name = "Name", url
        }
    }
