//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTest
//
//  Created by Илья on 29.08.2024.
//

import Foundation
import ImageFeed


final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    
    var view: ProfileViewViewProtocol?
    var viewDidLoadCalled = false
    var resetAccountCalled = false
    
    func viewDidLoad() {
         viewDidLoadCalled = true
    }
    
    func resetAccount() {
        resetAccountCalled = true
    }
}
