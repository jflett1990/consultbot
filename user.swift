import Foundation

class User {
    var id: String
    var username: String
    var email: String
    var profilePictureURL: URL?
    var accountType: AccountType

    init(id: String, username: String, email: String, profilePictureURL: URL?, accountType: AccountType) {
        self.id = id
        self.username = username
        self.email = email
        self.profilePictureURL = profilePictureURL
        self.accountType = accountType
    }
}

enum AccountType {
    case client
    case stylist
}
