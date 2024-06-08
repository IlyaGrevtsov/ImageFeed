//
//  ResponseBody.swift
//  ImageFeed
//
//  Created by Илья on 10.05.2024.
//

import Foundation
struct OAuthTokenResponseBody: Decodable {
    var accessToken  : String
    var tokenType    : String
    var scope        : String
    var createdAt    : Int
}

