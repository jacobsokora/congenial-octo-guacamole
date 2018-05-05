//
//  Model.swift
//  ScavengeQR
//
//  Created by Jacob Sokora on 4/30/18.
//  Copyright © 2018 ScavengeQR. All rights reserved.
//

import Foundation

struct Hunt: Codable {
    let id: String
    let name: String
    let description: String
    let location: String
    let clues: [Clue]
    let ownerId: String
}

struct Clue: Codable {
    let clueText: String
    let clueCode: String
}
