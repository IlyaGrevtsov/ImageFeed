//
//  WebViewPresenterSpy.swift
//  ImageFeedTest
//
//  Created by Илья on 07.08.2024.
//

import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadetCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadetCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    func code(from url: URL) -> String? {
        return nil
    }
}
