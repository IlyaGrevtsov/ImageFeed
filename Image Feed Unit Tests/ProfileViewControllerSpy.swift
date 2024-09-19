//
//  ProfileViewControllerSpy.swift
//  ImageFeedTest
//
//  Created by Илья on 29.08.2024.
//

import Foundation
import ImageFeed
import UIKit


final class ProfileViewControllerSpy: ProfileViewViewProtocol {
    
    var presenter: (any ImageFeed.ProfileViewPresenterProtocol)?
    var updateAvatarShowCalled = false
    var loadProfileShowCalled = false
    
    
    var labelName = UILabel()
    var labelLogin = UILabel()
    var descriptionLabel = UILabel()
    
    func updateAvatar(url: URL) {
        updateAvatarShowCalled = true
    }
    
    func loadProfile(_ profile: ImageFeed.Profile?) {
        loadProfileShowCalled = true
        if let profile {
            labelName.text = profile.name
            labelLogin.text = profile.loginName
            descriptionLabel.text = profile.bio
            
        }
    }
}
