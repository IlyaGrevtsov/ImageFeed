import UIKit

final class ProfileViewController: UIViewController {
    private var labelName = UILabel()
    private var labelLogin = UILabel()
    private var descriptionLabel = UILabel()
    private var label: UILabel?
    private let profileService = ProfileService.shared
    private let storage = OAuth2TokenStorage.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadProfile()
    }
 
        
    func loadProfile() {
      guard let profile = profileService.profile else {
        return
      }
    self.labelName.text = profile.name
    self.descriptionLabel.text = profile.bio
    self.labelLogin.text = profile.loginName
    }
    
        func prepareUI() {
            let image = UIImage(named: "Photo")
            let imageProfile = UIImageView (image: image)
            imageProfile.tintColor = .gray
            imageProfile.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageProfile)
            
            imageProfile.widthAnchor.constraint(equalToConstant: 70).isActive = true
            imageProfile.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            imageProfile.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
            imageProfile.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 32).isActive = true
            
            labelName.text = "Екатерина Новикова"
            labelName.font = UIFont.systemFont(ofSize: 23)
            
            labelName.textColor = .white
            labelName.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(labelName)
            
            labelName.leadingAnchor.constraint(equalTo: imageProfile.leadingAnchor).isActive = true
            labelName.topAnchor.constraint(equalTo: imageProfile.bottomAnchor, constant: 8).isActive = true
            
            labelName.widthAnchor.constraint(equalToConstant: 241).isActive = true
            labelName.heightAnchor.constraint(equalToConstant: 18).isActive = true
//            self.label = labelName
            
            labelLogin.text = "@ekaterina_nov"
            labelLogin.font = UIFont.systemFont(ofSize: 13)
            labelLogin.textColor = .gray
            labelLogin.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(labelLogin)
            
            labelLogin.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8).isActive = true
            labelLogin.leadingAnchor.constraint(equalTo: imageProfile.leadingAnchor).isActive = true
            
            labelLogin.widthAnchor.constraint(equalToConstant: 99).isActive = true
            labelLogin.heightAnchor.constraint(equalToConstant: 18).isActive = true
            
            
            descriptionLabel.text = "Hello, world!"
            descriptionLabel.font = UIFont.systemFont(ofSize: 13)
            descriptionLabel.textColor = .white
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(descriptionLabel)
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 162).isActive = true
            
            let button = UIButton.systemButton(
                with: UIImage(named: "logout_button")!,
                target: self,
                action: #selector(self.didTapButton)
            )
            button.tintColor = .ypRed
            
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
            button.centerYAnchor.constraint(equalTo: imageProfile.centerYAnchor).isActive = true
            
            button.widthAnchor.constraint(equalToConstant: 44).isActive = true
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
    
    @objc
    private func didTapButton() {
        
        label?.removeFromSuperview()
        label = nil
        
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
                
            }
        }
    }
}
