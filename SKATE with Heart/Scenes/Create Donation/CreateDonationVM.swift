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
    
    func saveDonationInfo(completion: @escaping (Bool, String) -> ()) {
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
                print(error)
                completion(false, Strings.somethingWentWrong)
                return
            }
            completion(true, Strings.donationSavedSuccessful)
        }
    }
    
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && donation?.isEmpty == false && pickupLocation?.isEmpty == false
        bindalbeIsFormValid.value = isFormValid
    }
}
