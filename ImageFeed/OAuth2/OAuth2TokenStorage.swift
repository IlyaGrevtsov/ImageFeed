import Foundation
import SwiftKeychainWrapper

protocol TokenStorage {
  var token: String? { get }
}

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let keychainWrapper = KeychainWrapper.standard
}
extension OAuth2TokenStorage: TokenStorage {
    var token: String? {
        get {
            keychainWrapper.string(forKey: Constants.bearerToken)
        }
        set {
            guard let newValue else {return}
            keychainWrapper.set(newValue, forKey: Constants.bearerToken)
        }
    }
}
extension OAuth2TokenStorage {

  func removeToken() -> Bool {
    keychainWrapper.removeObject(forKey: Constants.bearerToken)
  }
}
