import UIKit

enum AssertColor: String {
    case orange = "Orange"
    case pink = "Pink"
    case lightGray = "Light_Gray"
    case darkPink = "Dark_Pink"
}


extension UIColor {
    static func appColor(color: AssertColor) -> UIColor {
        return UIColor(named: color.rawValue)!
    }
}
