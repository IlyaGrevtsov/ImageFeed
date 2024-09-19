//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Илья on 16.08.2024.
//

import Foundation
import WebKit
import Kingfisher

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewViewProtocol? {get set}
    func viewDidLoad ()
    func resetAccount()
}
final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    weak var view: ProfileViewViewProtocol?
    
    func viewDidLoad() {
        checkAvatar()
        checkProfile()
        
    }
    func resetAccount() {
        resetToken()
        resetView()
        resetPhotos()
        resetCookies()
        switchSplash()
    }

    func checkAvatar () {
        if let url = profileImageService.avatarURL {
            view?.updateAvatar(url: url)
        }
    }
    
    func checkProfile() {
        guard let profile = profileService.profile else {
            return
        }
        view?.loadProfile(profile)
        
    }
    
    func resetToken(){
        guard OAuth2TokenStorage.shared.removeToken() else {
            assertionFailure("Can't remove token")
            return
        }
    }
    
    func resetView(){
        view?.loadProfile(nil)
    }
    
    func resetPhotos() {
        ImageListService.shared.resetPhotos()
    }
    
    func resetCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) { }
            }
        }
    }
    func switchSplash () {
        guard let window = UIApplication.shared.windows.first else {preconditionFailure("Invalid Configuration")}
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}
