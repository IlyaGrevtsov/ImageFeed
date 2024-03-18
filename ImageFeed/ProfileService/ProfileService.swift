import UIKit
protocol ProfileLoading: AnyObject {
  func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void)
}

final class ProfileService {
    static let shared = ProfileService()
    private var currentTask: URLSessionTask?
    private (set) var profile: Profile?
    private let urlSession = URLSession.shared
    private let requestBuilder: URLRequestBuilder
    
    
    init(requestBuilder: URLRequestBuilder = .shared) {
      self.requestBuilder = requestBuilder
    }
}
private extension ProfileService {

  func makeProfileRequest() -> URLRequest? {
    requestBuilder.makeHTTPRequest(path: Constants.profileRequestPathString)
  }
}
    extension ProfileService: ProfileLoading {
        func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
            assert(Thread.isMainThread)
            currentTask?.cancel()
            
            guard let request = makeProfileRequest() else {
                assertionFailure("Invalid Request")
                completion(.failure(NetworkError.invalidRequest))
                return
            }
            
            let session = URLSession.shared
            currentTask = session.objectTask(for: request){
                [weak self] (response: Result <ProfileResult, Error>) in
                
                self?.currentTask = nil
                switch response {
                case.success (let profileResult):
                    let profile = Profile(result: profileResult)
                    self?.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

 
