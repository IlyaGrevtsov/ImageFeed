import UIKit

final class SplashViewController: UIViewController {
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    private let storage = OAuth2TokenStorage()
    private let authService = OAuth2Service()
    private var alertPresenter: AlertPresenting?
    private var wasChecked = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkAuthStatus()
//        setNeedsStatusBarAppearanceUpdate()
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
    }


extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
       let alertModel =  AlertModel(
              title: "Что-то пошло не так :(",
              message: "Не удалось войти в систему: \(error.localizedDescription)",
              buttonText: "Ok") {
                  self.performSegue(withIdentifier: self.ShowAuthenticationScreenSegueIdentifier, sender: nil)
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
                self?.switchToTabBarController()
            case .failure(let error):
                self?.showLoginAlert(error: error)
            }
            completion()
        }
    }
}
