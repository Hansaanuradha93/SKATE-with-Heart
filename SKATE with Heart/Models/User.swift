import Foundation

struct User {
    
    // MARK: Properties
    let uid, email, fullName: String?
    let isAdminUser: Bool
    
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.uid = dictionary["uid"] as? String
        self.email = dictionary["email"] as? String
        self.fullName = dictionary["fullname"] as? String
        self.isAdminUser = (dictionary["isAdminUser"] as? Bool) ?? false
    }
}
