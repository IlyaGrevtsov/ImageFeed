//
//  AuthPresenterHelper.swift
//  ImageFeed
//
//  Created by Илья on 06.08.2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest () -> URLRequest
    func code (from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest {
      URLRequest(url: authURL())
    }
    
    func authURL() -> URL {
        guard var urlComponents = URLComponents(string: configuration.authURLString) else {
            preconditionFailure("Incorrect auth string: \(configuration.authURLString)")
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accesKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        guard let url = urlComponents.url else {
            preconditionFailure("Incorrect URL: \(configuration.defaultBaseURL)")
        }
        return url
    }
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
