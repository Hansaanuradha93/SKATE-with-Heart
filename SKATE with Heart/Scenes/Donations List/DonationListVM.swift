import Firebase

class DonationListVM {
    
    // MARK: Properties
    var donations = [Donation]()
    var user: User?
    fileprivate var donationsDictionary = [String : Donation]()
}


// MARK: - Public Methods
extension DonationListVM {
    
    func pickupDonation(donation: Donation?, completion: @escaping (Bool, String) -> ()) {
        if let donation = donation, let documentID = donation.id {
            let ref = Firestore.firestore().collection("donations").document(documentID)
            ref.updateData(["isPickedUp": true]) { (error) in
                if let error = error {
                    print(error)
                    completion(false, error.localizedDescription)
                    return
                }
                completion(true, Strings.donationPickedUpSuceessfully)
            }
        }
    }
    
    
    func fetchData(completion: @escaping (Bool) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docRef = Firestore.firestore().collection("users").document(uid)
        docRef.getDocument { (document, error) in
            if let error = error {
                print(error)
                completion(false)
                return
            }
            
            if let document = document, let dictionary = document.data() {
                self.user = User(dictionary: dictionary)
                self.fetchDonations(user: self.user!, completion: completion)
            }
        }
    }
}


// MARK: - Fileprivate Methods
fileprivate extension DonationListVM {
    
    func fetchDonations(user: User, completion: @escaping (Bool) -> ()) {
        if user.isAdminUser {
            self.fetchAllDonations(completion: completion)
        } else {
            self.fetchUserDonations(user: user, completion: completion)
        }
    }
    
    
    func fetchAllDonations(completion: @escaping (Bool) -> ()) {
        let reference = Firestore.firestore().collection("donations")
        reference.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            self.donations = []
            querySnapshot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                let donation = Donation(dictionary: dictionary)
                self.donationsDictionary[donation.id ?? ""] = donation
            })
            self.sortDonationsByTimestamp(completion: completion)
        }
    }
    
    
    func fetchUserDonations(user: User, completion: @escaping (Bool) -> ()) {
        let uid = user.uid ?? ""
        let reference = Firestore.firestore().collection("donations").whereField("uid", isEqualTo: uid)
        reference.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            self.donations = []
            querySnapshot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                let donation = Donation(dictionary: dictionary)
                self.donationsDictionary[donation.id ?? ""] = donation
            })
            self.sortDonationsByTimestamp(completion: completion)
        }
    }
    
    
    func sortDonationsByTimestamp(completion: @escaping (Bool) -> ()) {
        let values = Array(donationsDictionary.values)
        donations = values.sorted(by: { (donation1, donation2) -> Bool in
            guard let timestamp1 = donation1.timestamp, let timestamp2 = donation2.timestamp else { return false }
            return timestamp1.compare(timestamp2) == .orderedDescending
        })
        completion(true)
    }
}
