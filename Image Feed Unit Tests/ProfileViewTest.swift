//
//  ProfileViewTest.swift
//  ImageFeedTest
//
//  Created by Илья on 27.08.2024.
//

import Foundation
import XCTest
@testable import ImageFeed

final class ProfileViewPresenterTest: XCTestCase {

    
    let viewController = ProfileViewControllerSpy()
    let presenter = ProfileViewPresenter()
    
    func testLoadProfile () {
        //given
        let testText = "test"
        let testProfile = Profile(username: testText, name: testText, loginName: testText, bio: testText)
        
        //when
        viewController.loadProfile(testProfile)
        
        //then
        XCTAssertTrue(viewController.loadProfileShowCalled)
        XCTAssertEqual(viewController.labelName.text, testText)
        XCTAssertEqual(viewController.descriptionLabel.text, testText)
        XCTAssertEqual(viewController.labelLogin.text, testText)
    }
    
    func testUpdateAvatar () {
        //given
        
        let spyURL = URL(string: "https://unsplash.com")!
        
        //when
        viewController.updateAvatar(url: spyURL)
        
        //then
        XCTAssertTrue(viewController.updateAvatarShowCalled)
        
        
        
        
    }

}
