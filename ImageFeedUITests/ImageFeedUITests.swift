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
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 3))
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 3))
        
        let loginTextFiled = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextFiled.waitForExistence(timeout: 5))
        loginTextFiled.tap()
        loginTextFiled.typeText("email")
        webView.swipeUp()
        
        let passwordTextFiled = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextFiled.waitForExistence(timeout: 5))
        passwordTextFiled.tap()
        passwordTextFiled.typeText("pass")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        print(app.debugDescription)
        
        
    }
    func testFeed() throws {
      XCTAssertTrue(app.tabBars.buttons.element(boundBy: 0).waitForExistence(timeout: 3))

      let tableQuery = app.tables
      let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
      XCTAssertTrue(cell.waitForExistence(timeout: 3))
      cell.swipeDown()
      sleep(2)

      let cellTwo = tableQuery.children(matching: .cell).element(boundBy: 1)
      XCTAssertTrue(cell.waitForExistence(timeout: 3))
      XCTAssertTrue(cell.buttons["likeButton"].waitForExistence(timeout: 1))
      cellTwo.buttons["likeButton"].tap()
      sleep(3)
      cellTwo.buttons["likeButton"].tap()
      sleep(3)

      cellTwo.tap()
      let image = app.scrollViews.images.element(boundBy: 0)
      image.pinch(withScale: 3, velocity: 1)
      image.pinch(withScale: 0.5, velocity: -1)

      XCTAssertTrue(app.buttons["backtoGallery"].waitForExistence(timeout: 3))
      app.buttons["backtoGallery"].tap()
    }
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Name Last Name"].exists)
        XCTAssertTrue(app.staticTexts["login"].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["Alert"].scrollViews.otherElements.buttons["Да"].tap()
        
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 3))
    }

}
