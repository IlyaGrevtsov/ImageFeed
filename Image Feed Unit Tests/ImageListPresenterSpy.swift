//
//  ImageListPresenterSpy.swift
//  ImageFeedTest
//
//  Created by Илья on 27.08.2024.
//

import Foundation
import ImageFeed

final class ImageListPresenterSpy: ImageListPresenterProtocol {
    
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var photosCount: Int = 0
    
    var viewDidLoadCalled = false
    var updateTableViewAnimatedCalled = false
    
    var needUploadImageCalled = false
    var needUploadImageCalledHaveAtIndex = false
    
    var heightForRowAtCalled = false
    var heightForRowAtHaveAtIndex = false
    
    var imagesListCellDidTapLikeCalled = false
    var imagesListCellDidTapLikeHaveAtIndex = false
    
    var returnPhotoModelAtCalled = false
    var returnPhotoModelAtHaveAtIndex = false

    
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
    
    func needUploadImage(indexPath: IndexPath) {
        needUploadImageCalled = true
        if indexPath == IndexPath (row: 1,
                                   section: 0) {
            needUploadImageCalledHaveAtIndex = true
        }
    }
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        heightForRowAtCalled = true
        if indexPath == IndexPath (row: 1, 
                                   section: 0) {
            heightForRowAtHaveAtIndex = true
        }
        return CGFloat(100)
    }
    
    func imagesListCellDidTapLike(_ cell: ImageFeed.ImagesListCell, indexPath: IndexPath) {
        imagesListCellDidTapLikeCalled = true
        if indexPath == IndexPath(row: 1, 
                                  section: 0) {
            imagesListCellDidTapLikeHaveAtIndex = true
        }
    }
    
    func returnPhotoModelAt(indexPath: IndexPath) -> ImageFeed.Photo? {
        returnPhotoModelAtCalled = true
        if indexPath == IndexPath (row: 1,
                                   section: 0) {
            returnPhotoModelAtHaveAtIndex = true
        }
        return nil
    }
    
}
