import UIKit

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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return donationListViewModel.donations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DonationCell.reuseID, for: indexPath) as! DonationCell
        cell.setup(donation: donationListViewModel.donations[indexPath.item])
        return cell
    }
    
}
