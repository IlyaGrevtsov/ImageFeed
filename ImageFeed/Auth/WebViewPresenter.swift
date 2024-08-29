//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Илья on 31.07.2024.
//
import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? {get set}
    func viewDidLoad()
    func didUpdateProgressValue (_ newValue: Double)
    func code (from url: URL) -> String?
}

final class WebViewPresenter {
    
    private var webViewWasLoaded = false
    
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
}
extension WebViewPresenter {
    func shouldHideProgress (for value: Float) -> Bool {
        abs (value - 1.0) <= 0.0001
    }
}

extension WebViewPresenter: WebViewPresenterProtocol {
    func viewDidLoad() {
        let request = authHelper.authRequest()
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    
    func didUpdateProgressValue(_ newValue: Double) {
      if !webViewWasLoaded {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)

        let shouldProgressHidden = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldProgressHidden)
        if shouldProgressHidden {
          webViewWasLoaded = true
        }
      }
    }
        func code(from url: URL) -> String? {
            authHelper.code(from: url)
        }
    }
