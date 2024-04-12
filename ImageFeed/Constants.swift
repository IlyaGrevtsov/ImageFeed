import Foundation

 let AccessKey = "jpUG2ubiqkre46Xu1fTcDNkh2HsnBWv2BwgsqqsSnLM"
 let SecretKey = "b0k4PmJnAL1K7QGWSUTgvMr1lkS7KSpkzcaF8sRL-HE"
 let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
 let AccessScope = "public+read_user+write_likes"
 let DefaultBaseURL = URL(string: "https://api.unsplash.com")!

public enum Constants {
    
    static let defaultApiBaseURLString = "https://api.unsplash.com"
    static let secretKey: String = "b0k4PmJnAL1K7QGWSUTgvMr1lkS7KSpkzcaF8sRL-HE"
    
    static let profileRequestPathString = "/me"
    static let getMethodString = "GET"
    static let bearerToken = "bearerToken"
    static let getPhoto = "/photos"
}
