//
//  ImageFeedTest.swift
//  ImageFeedTest
//
//  Created by Илья on 07.08.2024.
//

@testable import ImageFeed
import Foundation
import XCTest

final class WebViewTests: XCTestCase {
    
    //Given
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        
        //When
        _ = viewController.view
        
        
        //Then
        XCTAssertTrue(presenter.viewDidLoadetCalled)
    }
    func testPresenterCallsLoadRequest() {
        //given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter (authHelper: authHelper)
        viewController.presenter = presenter as? any WebViewPresenterProtocol
        presenter.view = viewController
        //When
        presenter.viewDidLoad()
        
        //Then
        XCTAssertTrue(viewController.loadRequestCalled  )
    }
    func testProgressVisibleWhenLessThenOne() {
        //Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        //When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        //Then
        XCTAssertFalse(shouldHideProgress)
    }
    func testProgressHiddenWhenOne() {
        //Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        //When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        //Then
        XCTAssertTrue(shouldHideProgress)
    }
    func testAuthHelperAuthURL() {
        //Given
        let authConfiguration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: authConfiguration)
        //When
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        //Then
        XCTAssertTrue(urlString.contains(authConfiguration.authURLString))
        XCTAssertTrue(urlString.contains(authConfiguration.accesKey))
        XCTAssertTrue(urlString.contains(authConfiguration.accessScope))
        XCTAssertTrue(urlString.contains(authConfiguration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
    }
        
        func testCodeFromURL() {
            
            //Given
            let urlString = "https://unsplash.com/oauth/authorize/native"
            var urlComponents = URLComponents(string: urlString)!
            urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
            let url = urlComponents.url!
            let authHelper = AuthHelper()
            //When
            let code = authHelper.code(from: url)
            //Then
            XCTAssertEqual(code, "test code")
        }
}

