import UIKit

class DonationCell: UICollectionViewCell {
    
    static let reuseID = "DonationCell"
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 20
        layer.cornerRadius = 20.0
    }
    
    
    func setupUI() {
        backgroundColor = .white
        
        gradientLayer.colors = [UIColor.appColor(color: .orange).cgColor, UIColor.appColor(color: .pink).cgColor]
        gradientLayer.locations = [0, 1]
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
