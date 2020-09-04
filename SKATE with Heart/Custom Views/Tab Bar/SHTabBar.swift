import UIKit

class SHTabBar: UITabBarController {

    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor.appColor(color: .darkPink)
        viewControllers = [createDonationNC(), donationListNC()]
    }
}


// MARK: - Methods
extension SHTabBar {
    
    fileprivate func createDonationNC() -> UINavigationController {
        let createDonationVC = CreateDonationVC()
        createDonationVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "donate"), tag: 0)
        return UINavigationController(rootViewController: createDonationVC)
    }
    
    
    fileprivate func donationListNC() -> UINavigationController {
        let donationListVC = DonationListVC()
        donationListVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "skate"), tag: 1)
        return UINavigationController(rootViewController: donationListVC)
    }
}
