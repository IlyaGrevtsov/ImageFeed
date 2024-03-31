import Foundation

extension Notification {
    
    static let userInfoImageURLKey: String = "URL"
    
    var userInfoImageURL: String? {
        userInfo?[Notification.userInfoImageURLKey] as? String
    }
}
