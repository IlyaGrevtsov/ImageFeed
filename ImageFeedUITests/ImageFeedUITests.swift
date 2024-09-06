//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Илья on 05.09.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication() // переменная приложения

    override func setUpWithError() throws {

        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        webView.waitForExistence(timeout: 5)
        let loginTextFiled = webView.descendants(matching: .textField).element
        let passwordTextFiled = webView.descendants(matching: .secureTextField).element
        loginTextFiled.typeText("")
        webView.swipeUp()
        print(app.debugDescription)
        
        
    }
    func testFeed() throws {
        
    }
    
    func testProfile() throws {
        
    }

}
