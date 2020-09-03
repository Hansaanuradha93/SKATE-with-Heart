import UIKit
import Firebase

class SignUpVM {
    
    // MARK: Properties
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    
    // MARK: Bindlable
    var bindalbeIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
}


// MARK: - Methods
extension SignUpVM {
    
    func performSignUp(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        self.bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.bindableIsRegistering.value = false
                completion(error)
                return
            }
            self.saveInfoToFirestore(completion: completion)
        }
    }
    
    
    fileprivate func saveInfoToFirestore(completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let userInfo = [
            "uid": uid,
            "fullname": fullName ?? "",
            "email": email ?? "",
            "isAdminUser": false
            ] as [String : Any]
        Firestore.firestore().collection("users").document(uid).setData(userInfo) { [weak self] error in
            guard let self = self else { return }
            self.bindableIsRegistering.value = false
            if let error = error {
                completion(error)
                return
            }
            print("Authentication successfull")
            completion(nil)
        }
    }
    
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && password?.count ?? 0 >= 6
        bindalbeIsFormValid.value = isFormValid
    }
}
