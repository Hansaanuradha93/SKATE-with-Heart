import UIKit
import Firebase

class DonationListVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let donationListViewModel = DonationListVM()
    
    var collectionview: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchDonations()
    }
    
    
    fileprivate func fetchDonations() {
        self.showPreloader()
        donationListViewModel.fetchDonations { [weak self] status in
            guard let self = self else { return }
            self.hidePreloader()
            if status { DispatchQueue.main.async { self.collectionview.reloadData() } }
        }
    }
    
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Donation List"
        view.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 40
        layout.itemSize = CGSize(width: 275, height: 450)
        
        collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(DonationCell.self, forCellWithReuseIdentifier: DonationCell.reuseID)
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = .white
        view.addSubview(collectionview)
        collectionview.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    
    fileprivate func addAlert(donation: Donation?) {
        let alertController = UIAlertController(title: "Are you sure", message: "Did you pickup the donation?", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.updatePickupState(donation: donation)
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    
    fileprivate func updatePickupState(donation: Donation?) {
        if let donation = donation, let documentID = donation.id {
            let ref = Firestore.firestore().collection("donations").document(documentID)
            ref.updateData(["isPickedUp": true])
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return donationListViewModel.donations.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DonationCell.reuseID, for: indexPath) as! DonationCell
        cell.setup(donation: donationListViewModel.donations[indexPath.item])
        cell.donationCellDelegate = self
        return cell
    }
}


// MARK: - DonationCellDelegate
extension DonationListVC: DonationCellDelegate {
    
    func pickUpButtonTapped(donation: Donation?) {
       addAlert(donation: donation)
    }
}
