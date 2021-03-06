import UIKit

class SHTextField: UITextField {
    
    // MARK: Properties
    fileprivate var padding: CGFloat = 0
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    convenience init(padding: CGFloat, placeholderText: String = "", radius: CGFloat = 0) {
        self.init()
        self.padding = padding
        self.placeholder = placeholderText
        self.layer.cornerRadius = radius
    }
    
    
    required init?(coder: NSCoder) { fatalError() }

    
    // MARK: Overridden Methods
    override func editingRect(forBounds bounds: CGRect) -> CGRect { return bounds.insetBy(dx: padding, dy: 0) }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect { return bounds.insetBy(dx: padding, dy: 0) }
    
    
    override var intrinsicContentSize: CGSize { return .init(width: 0, height: 50) }
}


// MARK: - Methods
extension SHTextField {
    
    fileprivate func configure() {
        backgroundColor = .white
    }
    
    
    func setRoundedBorder(borderColor: UIColor, borderWidth: CGFloat, radius: CGFloat) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

