
import Foundation


public enum Constants {
    
    //MARK: - Unsplash const
    static let secretKey = "b0k4PmJnAL1K7QGWSUTgvMr1lkS7KSpkzcaF8sRL-HE"
    static let accessKey = "jpUG2ubiqkre46Xu1fTcDNkh2HsnBWv2BwgsqqsSnLM"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    //MARK: - Unsplash urls
    static let defaultApiBaseURLString = "https://api.unsplash.com"
    static let profileRequestPathString = "/me"
    static let photoPathString = "/photos"
    
    //MARK: - methods
    static let getMethodString = "GET"
    static let postMethodString = "POST"
    static let deleteMethodString = "DELETE"
    
    //MARK: - Storage const
    static let bearerToken = "bearerToken"
}
struct AuthConfiguration {
    let secretKey: String
    let accesKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(secretKey: String, accesKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.secretKey = secretKey
        self.accesKey = accesKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            secretKey: Constants.secretKey,
            accesKey: Constants.accessKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            defaultBaseURL: Constants.defaultBaseURL,
            authURLString: Constants.UnsplashAuthorizeURLString)
    }
}
