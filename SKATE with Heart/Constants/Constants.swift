import UIKit

struct Asserts {
    static let donate = UIImage(named: "donate")!
    static let skate = UIImage(named: "skate")!
}


struct Strings {
    
    // Titles
    static let donationList = "Donation List"
    static let createDonation = "Create Donation"
    
    // Alerts
    static let successful = "Successful"
    static let failed = "Failed"
    static let somethingWentWrong = "Something Went Wrong"
    static let areYouSure = "Are you sure"
    static let didYouPickupTheDonation = "Did you pickup the donation?"
    static let donationSavedSuccessful = "Donation saved successfully"
    static let yes = "Yes"
    static let no = "No"
    static let ok = "OK"
    
    // Placeholders
    static let yourName = "Your name"
    static let whatAreYouDonating = "What are you donating"
    static let pickupLocation = "Pickup location"
    static let enterFullName = "Enter full name"
    static let enterEmail = "Enter email"
    static let enterPassword = "Enter password"
    
    // View Models
    static let donationPickedUpSuceessfully = "Donation Picked Up Successfully"
    static let authenticationSuccessfull = "Authentication successfull"
    static let loginSuccessfully = "Logged in successfully"
    
    // Buttons
    static let saveDonation = "Save Donation"
    static let signup = "Sign Up"
    static let goToLogin = "Go to login"
    static let login = "Login"
    static let goToSignup = "Go to Signup"
}


struct GlobalDimensions {
    
    static let height: CGFloat = 50
    static let radius: CGFloat = 25
    static let buttonTitleFontSize: CGFloat = 24
    static let textFieldPadding: CGFloat = 16
    static let paddingBetweenItems: CGFloat = 20
    static let borderWidth: CGFloat = 0.5
}
