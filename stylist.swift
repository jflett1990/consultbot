import Foundation

class Stylist: User {
    var portfolio: [PortfolioItem]
    var biography: String
    var specialties: [String]
    var ratings: [Rating]

    init(id: String, username: String, email: String, profilePictureURL: URL?, biography: String, specialties: [String], ratings: [Rating], portfolio: [PortfolioItem]) {
        self.biography = biography
        self.specialties = specialties
        self.ratings = ratings
        self.portfolio = portfolio
        super.init(id: id, username: username, email: email, profilePictureURL: profilePictureURL, accountType: .stylist)
    }
}

struct PortfolioItem {
    var id: String
    var title: String
    var imageURL: URL
    var description: String
    // Additional details specific to a portfolio item...
}

struct Rating {
    var stars: Double
    var comment: String
    var date: Date
    // Other rating details...
}
