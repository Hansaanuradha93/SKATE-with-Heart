import Firebase

struct Donation {
    
    // MARK: Properties
    let id, uid, fullname, donation, location: String?
    let isPickedUp: Bool?
    let timestamp: Timestamp?
    
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.id = dictionary["id"] as? String
        self.uid = dictionary["uid"] as? String
        self.fullname = dictionary["fullname"] as? String
        self.donation = dictionary["donation"] as? String
        self.location = dictionary["location"] as? String
        self.isPickedUp = dictionary["isPickedUp"] as? Bool
        self.timestamp = dictionary["timestamp"] as? Timestamp
    }
}
