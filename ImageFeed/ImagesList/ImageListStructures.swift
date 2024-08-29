//
//  ImageListStructures.swift
//  ImageFeed
//
//  Created by Илья on 02.04.2024.
//

import Foundation

public struct Photo {
    public let id: String
    public let size: CGSize
    public let createdAt: Date?
    public let welcomeDescription: String?
    public let thumbImageURL: String
    public let largeImageURL: String
    public var isLiked: Bool
    public let thumbSize: CGSize
}


struct PhotoResult: Codable {
    let id: String
    let width, height: Int
    let createdAt: String?
    let description: String?
    let likedByUser: Bool
    let urls: Urls
}

// MARK: - Urls
struct Urls: Codable {
    let full, small: String
}

struct LikeResult: Codable {
    let photo: PhotoLikeResult
}

struct PhotoLikeResult: Codable {
    let likedByUser: Bool
}

