import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let requestBuilder = URLRequestBuilder.shared
    private (set) var avatarURL: URL?
    private var currentTask: URLSessionTask?
    
    func makeProfileRequest(userName: String) -> URLRequest? {
      requestBuilder.makeHTTPRequest(path: "/users/\(userName)")
    }
   
    func fetchProfileImageURL(userName: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        currentTask?.cancel()
        
        guard let request = makeProfileRequest(userName: userName) else {
            assertionFailure("Invalid Request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request){
            [weak self] (response: Result <ProfileResult, Error>) in
            guard let self = self else  {return}
            switch response {
            case.success (let profilePhoto):
                guard let mediumPhoto = profilePhoto.profileImage?.medium else {return}
                self.avatarURL = URL (string: mediumPhoto)
                completion(.success(mediumPhoto))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": mediumPhoto])
            case .failure(let error):
                completion(.failure(error))
            }
            self.currentTask = nil
        }
        self.currentTask = task
        task.resume ()
    }
    
}
