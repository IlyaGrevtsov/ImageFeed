//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Илья on 02.04.2024.
//

import UIKit

final class ImagesListService: UIViewController {
    static let shared = ImagesListService()
    private (set) var photos: [Photo] = []
    private var lastLoadetPage: Int?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let requestBuilder = URLRequestBuilder.shared
    private var currentTask: URLSessionTask?
    private let session = URLSession.shared

    
    
    func showNextPage(page: Int) -> URLRequest? {
        requestBuilder.makeHTTPRequest(path: Constants.getPhoto + "page?=\(page)")
    }
    
    func nextPage() -> Int {
        guard let lastLoadetPage else {return 1}
        return lastLoadetPage + 1
        
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)

        guard currentTask == nil else {
            debugPrint("Race Condition - reject repeated photos request")
            return
        }

        
        let nextPage = nextPage()
        
        guard let request = showNextPage(page: nextPage) else {
            assertionFailure("Invalid Request")
            debugPrint(NetworkError.invalidRequest)
            return
        }
        
       let task = session.objectTask(for: request){
            [weak self] (response: Result <PhotoResult, Error>) in
            guard let self else { preconditionFailure("Cannot make weak link")}
            switch response {
            case .success(let photoResults):
                DispatchQueue.main.async {
                    var photos: [Photo] = []
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
