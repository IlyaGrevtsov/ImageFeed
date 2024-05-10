//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Илья on 02.04.2024.
//

import UIKit

protocol ImageListLoading: AnyObject {
    func fetchPhotosNextPage()
    func resetPhotos()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void)
}


final class ImagesListService {
    static let shared = ImagesListService()
    static let dateFormatter = ISO8601DateFormatter()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let requestBuilder = URLRequestBuilder.shared
    private let session = URLSession.shared
    
    private (set) var photos: [Photo] = []
    private var lastLoadetPage: Int?
    private var currentTask: URLSessionTask?
    private init() {}
    
    
    
    func showNextPage(page: Int) -> URLRequest? {
        requestBuilder.makeHTTPRequest(path: Constants.getPhoto + "page?=\(page)")
    }
    func makeLikeRequest(for id: String, with method: String) -> URLRequest? {
        requestBuilder.makeHTTPRequest(path: "/photos/\(id)/like", httpMethod: method)
    }
    
    func makeNextPageNumber() -> Int {
        guard let lastLoadetPage else {return 1}
        return lastLoadetPage + 1
        
    }
    func convert(result photoResult: PhotoResult) -> Photo {
        let thumbWidth = 200.0
        let aspectRatio = Double(photoResult.width) / Double(photoResult.height)
        let thumbHeight = thumbWidth / aspectRatio
        return Photo(
            id: photoResult.id,
            size: CGSize(width: Double(photoResult.width), height: Double(photoResult.height)),
            createdAt: ImagesListService.dateFormatter.date(from: photoResult.createdAt ?? ""),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.small,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser,
            thumbSize: CGSize(width: thumbWidth, height: thumbHeight)
        )
        
    }
}
extension ImagesListService: ImageListLoading {
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard currentTask == nil else { return }
        let method = isLike ? Constants.postMethodString : Constants.deleteMethodString
        
        guard let request = makeLikeRequest(for: photoId, with: method) else {
            assertionFailure("Invalid request")
            print(NetworkError.invalidRequest)
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let photoLiked):
                    let likedByUser = photoLiked.photo.likedByUser
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: likedByUser,
                            thumbSize: photo.thumbSize
                        )
                        self.photos[index] = newPhoto
                    }
                    completion(.success(likedByUser))
                    self.currentTask = nil
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        currentTask = task
        task.resume()
    }
    func resetPhotos() {
        photos = []
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        guard currentTask == nil else {
            debugPrint("Race Condition - reject repeated photos request")
            return
        }
        let nextPage = makeNextPageNumber()
        
        guard let request = showNextPage(page: nextPage) else {
            assertionFailure("Invalid request")
            debugPrint(NetworkError.invalidRequest)
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { preconditionFailure("Cannot make weak link") }
            switch result {
            case .success(let photoResults):
                DispatchQueue.main.async {
                    var photos: [Photo] = []
                    photoResults.forEach { photo in
                        photos.append(self.convert(result: photo))
                    }
                    self.photos += photos
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                    self.lastLoadetPage = nextPage
                }
            case .failure(let error):
                debugPrint("Error: \(String(describing: error))")
            }
            self.currentTask = nil
        }
        currentTask = task
        task.resume()
    }
}
