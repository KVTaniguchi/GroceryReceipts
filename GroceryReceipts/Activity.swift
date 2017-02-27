//
//  Activity.swift
//  GroceryReceipts
//
//  Created by Kevin Taniguchi on 2/26/17.
//  Copyright © 2017 Kevin Taniguchi. All rights reserved.
//

import Foundation

struct Group {
    let title: String
}

struct Activity {
    let date: Date
    let group: Group
    let detail: String
}

// user created entries
// icloud or no icloud?
// core data?
