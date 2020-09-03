import UIKit

class DonationListVC: UIViewController {

    let donationListViewModel = DonationListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Donation List"
        view.backgroundColor = .white
    }
}
