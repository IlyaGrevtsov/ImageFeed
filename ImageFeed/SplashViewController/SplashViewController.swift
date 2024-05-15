import UIKit

final class SplashViewController: UIViewController {
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imageListService = ImageListService.shared
    private let authService = OAuth2Service()
    private var alertPresenter: AlertPresenting?
    private var wasChecked = false
    
    private lazy var unsplashLogoImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash_screen_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(viewController: self)
        setupSplashViewController()
        imageListService.fetchPhotoNextPage()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthStatus()
    }
}
private extension SplashViewController {
    func showAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
        guard let viewController = viewController as? AuthViewController else { return }
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    func setupSplashViewController () {
        view.backgroundColor = .yBlack
        view.addSubview(unsplashLogoImage)
        
        NSLayoutConstraint.activate([
            unsplashLogoImage.widthAnchor.constraint(equalToConstant: 75),
            unsplashLogoImage.heightAnchor.constraint(equalToConstant: 77),
            unsplashLogoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            unsplashLogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
    }
    
}

extension SplashViewController {
    func checkAuthStatus() {
        guard !wasChecked else { return }
        wasChecked = true
        if authService.isAuthenticated {
            UIBlockingProgressHUD.show()
            
            fetchProfile { [weak self] in
                UIBlockingProgressHUD.dismiss()
                self?.switchToTabBarController()
            }
        } else {
            showAuthViewController()
        }
    }
    
    func showLoginAlert(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alertModel = AlertModel(
                title: "Что-то пошло не так :(",
                message: "Не удалось войти в систему: \(error.localizedDescription)",
                buttonText: "Ok") { [weak self] in
                    guard let self = self else { return }
                    self.wasChecked = false
                    guard OAuth2TokenStorage.shared.removeToken() else {
                        assertionFailure("Cannot remove token")
                        return
                    }
                    self.checkAuthStatus()
                }
            self.alertPresenter?.showAlert(for: alertModel)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        authService.fetchOAuthToken(with: code) { [weak self] authResult in
            switch authResult {
            case .success(_):
                self?.fetchProfile(completion: {
                    UIBlockingProgressHUD.dismiss()
                })
            case .failure(let error):
                self?.showLoginAlert(error: error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    private func fetchProfile(completion: @escaping () -> Void) {
        profileService.fetchProfile { [weak self] profileResult in
            switch profileResult {
            case .success(let profile):
                let userName = profile.username
                self?.fetchProfileImage (userName: userName)
                self?.switchToTabBarController()
            case .failure(let error):
                self?.showLoginAlert(error: error)
            }
            completion()
        }
    }
    func fetchProfileImage(userName: String) {
        
        profileImageService.fetchProfileImageURL(userName: userName) { [weak self] profileImageUrl in
            
            guard let self else { return }
            
            switch profileImageUrl {
            case .success(let mediumPhoto):
                print("Photo Link:  \(mediumPhoto)")
            case .failure(let error):
                self.showLoginAlert(error: error)
            }
        }
    }
    
}


