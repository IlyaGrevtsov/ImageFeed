//
//  ProfileViewPresenterTest.swift
//  ImageFeedTest
//
//  Created by Илья on 30.08.2024.
//

@testable import ImageFeed
import Foundation
import XCTest


final class ProfileViewTest: XCTestCase {
    
    let presenter = ProfileViewPresenterSpy()
    let viewController = ProfileViewController()
    
    override func setUpWithError() throws {
        //given
        viewController.presenter = presenter
        presenter.view = viewController
    }
    
    func testCalledViewDidLoad () {
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
        
    }
    
    func testResetAccount() {
        //when
        _ = viewController.view
        presenter.resetAccount()
        
        //then
        XCTAssertTrue(presenter.resetAccountCalled)
    }
}
