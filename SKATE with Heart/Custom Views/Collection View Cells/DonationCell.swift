import UIKit

class DonationCell: UICollectionViewCell {
    
    // MARK: Properties
    static let reuseID = "DonationCell"
    
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let titleLabel = SHLabel(numberOfLines: 0)
    fileprivate let pickupLocationLabel = SHLabel(numberOfLines: 0)
    fileprivate let pickupButton = SHButton(backgroundColor: .white, title: "Pick Up", titleColor: UIColor.appColor(color: .pink), radius: 20, fontSize: 20)
    fileprivate let pickupStateLabel = SHLabel(textColor: .white)
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    // MARK: Cell
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 20
    }
}


// MARK: - Methods
extension DonationCell {
    
    func setup(donation: Donation) {
        titleLabel.attributedText = NSMutableAttributedString().bold("\(donation.donation ?? "")\n", 22).normal("donated by \(donation.fullname ?? "")", 18)
        pickupLocationLabel.text = "Donations can be picked up at,\n\(donation.location ?? "")"
        pickupStateLabel.text = (donation.isPickedUp ?? false) ? "Already Picked Up" : "Yet to Pick Up"
    }
    
    
    fileprivate func setupUI() {
        backgroundColor = .clear
        
        gradientLayer.colors = [UIColor.appColor(color: .orange).cgColor, UIColor.appColor(color: .pink).cgColor]
        gradientLayer.locations = [0, 1]
        layer.insertSublayer(gradientLayer, at: 0)
        
        addSubview(titleLabel)
        addSubview(pickupLocationLabel)
        addSubview(pickupButton)
        addSubview(pickupStateLabel)
        
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 25, left: 25, bottom: 0, right: 25))
        pickupLocationLabel.anchor(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: nil, trailing: titleLabel.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0))
        pickupStateLabel.anchor(top: pickupLocationLabel.bottomAnchor, leading: pickupLocationLabel.leadingAnchor, bottom: nil, trailing: pickupLocationLabel.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0))
        pickupButton.anchor(top: nil, leading: pickupLocationLabel.leadingAnchor, bottom: bottomAnchor, trailing: pickupLocationLabel.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 25, right: 0), size: .init(width: 0, height: 40))
    }
}
