import UIKit

public protocol ProfileViewViewProtocol:AnyObject {
    var presenter: ProfileViewPresenterProtocol? {get set}
    func updateAvatar (url: URL)
    func loadProfile(_ profile: Profile?)
}

final class ProfileViewController: UIViewController  {
    
    private let userPickImageView = UIImageView()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let storage = OAuth2TokenStorage.shared
    
    private var labelName = UILabel()
    private var labelLogin = UILabel()
    private var descriptionLabel = UILabel()
    private var label: UILabel?
    internal var presenter: ProfileViewPresenterProtocol?
    private var alertPresenter: AlertPresenting?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        prepareUI()
        presenter?.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
    }
    

    private func updateAvatar(notification: Notification) {
        guard
            isViewLoaded,
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo[Notification.userInfoImageURLKey] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        updateAvatar (url: url)
    }
    
    func setupNotificationObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ){ [weak self] notification in
            self?.updateAvatar(notification: notification)
        }
    }
    func prepareUI() {
        // MARK: - image
        userPickImageView.tintColor = .gray
        userPickImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userPickImageView)
        userPickImageView.clipsToBounds = true
        userPickImageView.layer.cornerRadius = 35
        
        
        userPickImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userPickImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        userPickImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        userPickImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 32).isActive = true
        
        // MARK: - Label - Name
        labelName.text = "Екатерина Новикова"
        labelName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        labelName.textColor = .white
        labelName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelName)
        
        labelName.leadingAnchor.constraint(equalTo: userPickImageView.leadingAnchor).isActive = true
        labelName.topAnchor.constraint(equalTo: userPickImageView.bottomAnchor, constant: 8).isActive = true
        
        // MARK: - Label - login
        labelLogin.text = "@ekaterina_nov"
        labelLogin.font = UIFont.systemFont(ofSize: 13)
        labelLogin.textColor = .gray
        labelLogin.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelLogin)
        
        labelLogin.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8).isActive = true
        labelLogin.leadingAnchor.constraint(equalTo: userPickImageView.leadingAnchor).isActive = true
        // MARK: - Label - bio
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 162).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        // MARK: - button - exitProfile
        
        let button = UIButton.systemButton(
            with: UIImage(named: "logout_button")!,
            target: self,
            action: #selector(self.didTapButton)
        )
        button.tintColor = .ypRed
        button.accessibilityIdentifier = "logoutButton"

        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        button.centerYAnchor.constraint(equalTo: userPickImageView.centerYAnchor).isActive = true
        
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc
    private func didTapButton() {
        showAlert()
        print("Выход из профиля")
        
    }
}
 extension ProfileViewController: ProfileViewViewProtocol {
     
     func showAlert() {
         DispatchQueue.main.async { [weak self] in
             guard let self else { return }
             let alertModel = AlertModel(
                 title: "Выход",
                 message: "Уверены, что хотите выйти?",
                 buttonText: "Да",
                 completion: { self.presenter?.resetAccount() },
                 secondButtonText: "Нет",
                 secondCompletion: { self.dismiss(animated: true) }
             )
             self.alertPresenter?.showAlert(for: alertModel)
         }
     }
    
     func loadProfile(_ profile: Profile?) {
         if let profile {
             labelName.text = profile.name
             labelLogin.text = profile.loginName
             descriptionLabel.text = profile.bio
         } else {
             labelName.text = ""
             labelLogin.text = ""
             descriptionLabel.text = ""
         }
     }
     
      func updateAvatar (url: URL){
         userPickImageView.kf.indicatorType = .activity
         userPickImageView.kf.setImage(with: url,
                                       placeholder: UIImage (named: "person.crop.circle.fill"))
     }
}
