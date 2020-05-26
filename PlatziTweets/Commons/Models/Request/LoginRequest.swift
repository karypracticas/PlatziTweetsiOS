//
//  LoginRequest.swift
//  PlatziTweets
//
//  Created by Kary on 26/05/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}
