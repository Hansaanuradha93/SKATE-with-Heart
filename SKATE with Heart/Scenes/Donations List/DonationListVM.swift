import Firebase

class DonationListVM {
    
    var donations = [Donation]()
    var user: User?
    
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
    
    
    fileprivate func fetchDonations(user: User, completion: @escaping (Bool) -> ()) {
        if user.isAdminUser {
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
                    self.donations.append(donation)
                })
                completion(true)
            }
        } else {
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
                    self.donations.append(donation)
                })
                completion(true)
            }
        }
        
    }
}
