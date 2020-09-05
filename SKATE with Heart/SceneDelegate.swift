import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        var controller: UIViewController!
        if checkIfUserLoggedIn() {
            controller = SHTabBar()
        } else {
            controller = LoginVC()
        }

        window.rootViewController = controller
        self.window = window
        window.makeKeyAndVisible()
    }
    
    
    fileprivate func checkIfUserLoggedIn() -> Bool {
        if let _ = Auth.auth().currentUser {
            return true
        } else {
            return false
        }
    }
}

