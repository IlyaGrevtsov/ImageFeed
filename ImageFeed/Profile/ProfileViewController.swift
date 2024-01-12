import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var statucLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction private func didTapLogoutButton() {
    }
}

