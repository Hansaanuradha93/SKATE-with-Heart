import UIKit
import Firebase

class DonationListVC: UIViewController {

    // MARK: Properties
    let viewModel = DonationListVM()
    var collectionview: UICollectionView!

    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchDonations()
    }
}


// MARK: - Methods
extension DonationListVC {
    
    fileprivate func fetchDonations() {
        showPreloader()
        viewModel.fetchData { [weak self] status in
            guard let self = self else { return }
            self.hidePreloader()
            if status { DispatchQueue.main.async { self.collectionview.reloadData() } }
        }
    }
    
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Strings.donationList
        view.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 40
        layout.itemSize = CGSize(width: 275, height: 450)
        
        collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.register(DonationCell.self, forCellWithReuseIdentifier: DonationCell.reuseID)
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = .white
        view.addSubview(collectionview)
        collectionview.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    
    fileprivate func displayAlert(donation: Donation?) {
        self.presentAlertAction(title: Strings.areYouSure, message: Strings.didYouPickupTheDonation, rightButtonTitle: Strings.yes, leftButtonTitle: Strings.no, rightButtonAction:  { (_) in
            self.updatePickupState(donation: donation)
        })
    }
    
    
    fileprivate func updatePickupState(donation: Donation?) {
        viewModel.pickupDonation(donation: donation) { status, message in
            if status { print(message) }
        }
    }
}


// MARK: - UICollectionViewDataSource
extension DonationListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.donations.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DonationCell.reuseID, for: indexPath) as! DonationCell
        cell.setup(donation: viewModel.donations[indexPath.item], user: viewModel.user)
        cell.donationCellDelegate = self
        return cell
    }
}


// MARK: - DonationCellDelegate
extension DonationListVC: DonationCellDelegate {
    
    func pickUpButtonTapped(donation: Donation?) {
        displayAlert(donation: donation)
    }
}
