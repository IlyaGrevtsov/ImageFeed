//
//  SnakeCase.swift
//  ImageFeed
//
//  Created by Илья on 02.05.2024.
//

import Foundation

class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
