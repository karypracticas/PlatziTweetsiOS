//
//  RegisterRequest.swift
//  PlatziTweets
//
//  Created by Kary on 26/05/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let names: String
}
