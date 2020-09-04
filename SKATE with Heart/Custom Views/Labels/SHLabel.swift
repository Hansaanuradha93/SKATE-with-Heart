import UIKit

class SHLabel: UILabel {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) { fatalError() }

    
    convenience init(text: String = "", textAlignment: NSTextAlignment = .left, textColor: UIColor = .white, fontSize: CGFloat = 16, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        self.text = text
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.numberOfLines = numberOfLines
    }
}
