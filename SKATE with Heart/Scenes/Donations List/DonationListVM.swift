import Firebase

class DonationListVM {
    
    var donations = [Donation]()
    
    
    func fetchDonations(completion: @escaping (Bool) -> ()) {
        let reference = Firestore.firestore().collection("donations")
//        db.collection("cities").whereField("state", isEqualTo: "CA")
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
