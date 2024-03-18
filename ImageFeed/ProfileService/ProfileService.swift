import UIKit

final class ProfileService {
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
    }
    
    struct ProfileResult: Codable {
        let userName: String
        let firstName: String
        let lastName: String
        let bio: String
        
        enum codingKeys: String, CodingKey {
            case userName = "username"
            case firstName = "first_name"
            case lastName = "last_name"
            case bio = "bio"
        }
    }
    struct Profile {
        let userName: String
        let name: String
        let loginName: String
        let bio: String
    }
    func makeRequest(code: String) -> URLRequest? {
        makeRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}

