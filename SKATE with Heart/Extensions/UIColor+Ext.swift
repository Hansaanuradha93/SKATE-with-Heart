import UIKit

enum AssertColor: String {
    case white = "white"
}


extension UIColor {
    static func appColor(color: AssertColor) -> UIColor {
        return UIColor(named: color.rawValue)!
    }
}
