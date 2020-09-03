import UIKit

class DonationCell: UICollectionViewCell {
    
    static let reuseID = "DonationCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    func setupUI() {
        backgroundColor = .red
    }
}
