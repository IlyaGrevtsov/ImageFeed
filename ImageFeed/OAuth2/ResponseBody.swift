//
//  ResponseBody.swift
//  ImageFeed
//
//  Created by Илья on 10.05.2024.
//

import Foundation
struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}

