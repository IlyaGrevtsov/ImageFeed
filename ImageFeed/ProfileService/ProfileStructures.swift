import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
}

struct Profile {
  let username: String
  let name: String
  let loginName: String
  let bio: String?
}

struct ProfileImage: Codable {
  let small: String?
  let medium: String?
  let large: String?
}




// MARK: - Init for ProfileResult

extension Profile {

  init(result profile: ProfileResult) {
    self.init(
      username: profile.username,
      name: "\(profile.firstName ?? "") \(profile.lastName ?? "")",
      loginName: "@\(profile.username)",
      bio: profile.bio
    )
  }
}
