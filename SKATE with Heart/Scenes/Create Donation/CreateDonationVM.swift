import UIKit
import Firebase

class CreateDonationVM {
    
    // MARK: Properties
    var fullName: String? { didSet { checkFormValidity() } }
    var donation: String? { didSet { checkFormValidity() } }
    var pickupLocation: String? { didSet { checkFormValidity() } }
    
    
    // MARK: Bindlable
    var bindalbeIsFormValid = Bindable<Bool>()
    var bindableIsSaving = Bindable<Bool>()
}


// MARK: - Methods
extension CreateDonationVM {
    
//    func performSignUp(completion: @escaping (Error?) -> ()) {
//        guard let email = email, let password = password else { return }
//        self.bindableIsRegistering.value = true
//        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
//            guard let self = self else { return }
//            if let error = error {
//                self.bindableIsRegistering.value = false
//                completion(error)
//                return
//            }
//            self.saveInfoToFirestore(completion: completion)
//        }
//    }
    
    
//    fileprivate func saveInfoToFirestore(completion: @escaping (Error?) -> ()) {
//        let uid = Auth.auth().currentUser?.uid ?? ""
//        let userInfo = [
//            "uid": uid,
//            "fullname": fullName ?? "",
//            "email": email ?? "",
//            "isAdminUser": false
//            ] as [String : Any]
//        Firestore.firestore().collection("users").document(uid).setData(userInfo) { [weak self] error in
//            guard let self = self else { return }
//            self.bindableIsRegistering.value = false
//            if let error = error {
//                completion(error)
//                return
//            }
//            print("Authentication successfull")
//            completion(nil)
//        }
//    }
    
    func saveDonationInfo(completion: @escaping (Error?) -> ()) {
        self.bindableIsSaving.value = true
        let reference = Firestore.firestore().collection("donations")
        let documentId = reference.document().documentID
        let uid = Auth.auth().currentUser?.uid ?? ""
        let donationInfo: [String : Any] = [
            "id": documentId,
            "uid": uid,
            "fullname": fullName ?? "",
            "donation": donation ?? "",
            "location": pickupLocation ?? "",
            "isPickedUp": false,
            "timestamp": Timestamp(date: Date())
        ]
        
        reference.document(documentId).setData(donationInfo) { [weak self] error in
            guard let self = self else { return }
            self.bindableIsSaving.value = false
            if let error = error {
                completion(error)
                return
            }
            print("Donation saved successfully")
            completion(nil)
        }
    }
    
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && donation?.isEmpty == false && pickupLocation?.isEmpty == false
        bindalbeIsFormValid.value = isFormValid
    }
}
