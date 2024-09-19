//
//  ImageListTest.swift
//  ImageFeedTest
//
//  Created by Илья on 27.08.2024.
//
@testable import ImageFeed
import XCTest

final class ImageListTest: XCTestCase {
    
    let viewController = ImagesListViewController()

    let presenter = ImageListPresenterSpy()
    let indexPath = IndexPath (row: 1, section: 0)
    
    //given
    override func setUpWithError() throws {
        viewController.presenter = presenter
        presenter.view = viewController
     }
    
    func testViewDidloadCalled () {
        //when
//        _ = viewController.view
        //Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testupdateTableViewAnimatedCalled () {
        //when
        _ = viewController.view
        presenter.updateTableViewAnimated()
        
        //then
        XCTAssertTrue(presenter.updateTableViewAnimatedCalled)
    }
    
    func testNeedUploadImage () {
        //when
//        _ = viewController.view
        presenter.needUploadImage(indexPath: indexPath)
        presenter.heightForRowAt(indexPath: indexPath)
        
        //then
        XCTAssertTrue(presenter.needUploadImageCalled)
        XCTAssertTrue(presenter.heightForRowAtHaveAtIndex)
    }
    func testHeightForRowAt () {
        //when
//        _ = viewController.view
        let result = presenter.heightForRowAt(indexPath: indexPath)
        //then
        XCTAssertTrue(presenter.heightForRowAtCalled)
        XCTAssertTrue(presenter.heightForRowAtHaveAtIndex)
        XCTAssertEqual(result, CGFloat(100))
    }
    func testReturnPhotoModelAt() {
        //when
//        _ = viewController.view
        _ = presenter.returnPhotoModelAt(indexPath: indexPath)
        //then
        XCTAssertTrue(presenter.returnPhotoModelAtCalled)
        XCTAssertTrue(presenter.returnPhotoModelAtHaveAtIndex)
    }
}
