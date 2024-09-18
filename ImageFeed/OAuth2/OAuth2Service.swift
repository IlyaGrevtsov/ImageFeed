import Foundation

struct OAuth2Constants {
    static let authTokenURL = "https://unsplash.com/oauth/token"
    static let requestURL = "https://unsplash.com"
    static let requestPath = "/oauth/token"
    static let requestMethod = "POST"
    static let requestGrantType = "authorization_code"
    
    static let clientID = "client_id"
    static let clientSecret = "client_secret"
    static let redirectURI = "redirect_uri"
    static let grandType = "grant_type"
    static let code = "code"
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let builder: URLRequestBuilder
    private var currentTask: URLSessionTask?
    private var lastCode: String?
    private var urlSession = URLSession.shared
    private let storage: OAuth2TokenStorage
    private var task : URLSessionTask?
    
    init(
        urlSession: URLSession = .shared,
        storage: OAuth2TokenStorage = .shared,
        builder: URLRequestBuilder = .shared
    ){
        self.urlSession = urlSession
        self.storage = storage
        self.builder = builder
    }
    
    private(set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    var isAuthenticated: Bool {
        storage.token != nil 
    }
    
    
    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        guard code != lastCode else { return }
        task?.cancel()
        lastCode = code
        print("Done", "LastCode:",lastCode)
        
        guard let request = makeRequest(code: code) else {
            assertionFailure("Error Reguest")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task = urlSession.objectTask(for: request) {
            [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            self.task = nil
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.storage.token = authToken
                self.lastCode = nil
                completion(.success(authToken))
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
            }
        }
    }
    
    func makeRequest(code: String) -> URLRequest? {
        
        var urlComponents = URLComponents(string: OAuth2Constants.authTokenURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: OAuth2Constants.clientID, value: Constants.accessKey),
            URLQueryItem(name: OAuth2Constants.clientSecret, value: Constants.secretKey),
            URLQueryItem(name: OAuth2Constants.redirectURI, value: Constants.redirectURI),
            URLQueryItem(name: OAuth2Constants.code, value: code),
            URLQueryItem(name: OAuth2Constants.grandType, value: OAuth2Constants.requestGrantType)
        ]
        
        guard let urlWithQuery = urlComponents?.url else {
            preconditionFailure("Не удается создать URL с параметрами")
        }
        
        var request = URLRequest(url: urlWithQuery)
        request.httpMethod = OAuth2Constants.requestMethod
        
        return request
    }
}




