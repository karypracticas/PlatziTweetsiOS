//
//  PostRequest.swift
//  PlatziTweets
//
//  Created by Kary on 26/05/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import Foundation

struct PostRequest: Codable {
    let text: String
    let imageUrl: String?
    let videoUrl: String?
    let location: PostRequestLocation?
}
