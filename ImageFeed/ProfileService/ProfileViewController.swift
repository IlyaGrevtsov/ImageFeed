import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
    private let userPickImageView = UIImageView()
    private var labelName = UILabel()
    private var labelLogin = UILabel()
    private var descriptionLabel = UILabel()
    private var label: UILabel?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let storage = OAuth2TokenStorage.shared
    private var alertPresenter: AlertPresenting?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        prepareUI()
        checkAvatar ()
        loadProfile()
        alertPresenter = AlertPresenter(viewController: self)
    }
    func showAlert() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alertModel = AlertModel(
                title: "Выход",
                message: "Уверены, что хотите выйти?",
                buttonText: "Да",
                completion: { self.resetAccount() },
                secondButtonText: "Нет",
                secondCompletion: { self.dismiss(animated: true) }
            )
            self.alertPresenter?.showAlert(for: alertModel)
        }
    }
    
    func checkAvatar () {
        if let url = profileImageService.avatarURL {
            updateAvatar(url: url)
        }
    }
    func loadProfile() {
        guard let profile = profileService.profile else {
            assertionFailure("no add profile")
            return
        }
        self.labelName.text = profile.name
        self.descriptionLabel.text = profile.bio
        self.labelLogin.text = profile.loginName
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
    private func updateAvatar (url: URL){
        userPickImageView.kf.indicatorType = .activity
        userPickImageView.kf.setImage(with: url,
                                      placeholder: UIImage (named: "person.crop.circle.fill"))
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
private extension ProfileViewController {
    func resetAccount() {
        resetToken()
        resetView()
        resetPhotos()
        resetCookies()
        switchSplash()
    }
    func resetToken(){
        guard storage.removeToken() else {
            assertionFailure("Can't remove token")
            return
        }
    }
    func resetView(){
        self.labelName.text = "User Name"
        self.labelLogin.text = "@login"
        self.descriptionLabel.text = "bio"
        self.userPickImageView.image = UIImage(systemName: "person.fill.questionmark")
    }
    func resetPhotos() {
        ImageListService.shared.resetPhotos()
    }
    
    func resetCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) { }
            }
        }
    }
    func switchSplash () {
        guard let window = UIApplication.shared.windows.first else {preconditionFailure("Invalid Configuration")}
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
// MARK: -Animation:
    
}
