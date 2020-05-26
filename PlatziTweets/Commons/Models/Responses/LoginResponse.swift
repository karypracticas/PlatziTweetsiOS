//
//  LoginResponse.swift
//  PlatziTweets
//
//  Created by Kary on 26/05/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let user: User
    let token: String
}
