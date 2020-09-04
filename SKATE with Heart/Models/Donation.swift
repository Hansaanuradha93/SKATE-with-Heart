import Firebase

struct Donation {
    let uid, fullname, donation, location: String?
    let isPickedUp: Bool?
    let timestamp: Timestamp?
    
    init(dictionary: [String : Any]) {
        self.uid = dictionary["uid"] as? String
        self.fullname = dictionary["fullname"] as? String
        self.donation = dictionary["donation"] as? String
        self.location = dictionary["location"] as? String
        self.isPickedUp = dictionary["isPickedUp"] as? Bool
        self.timestamp = dictionary["timestamp"] as? Timestamp
    }
}
