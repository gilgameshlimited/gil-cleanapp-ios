import UIKit
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let manager = IQKeyboardManager.shared()
        manager.isEnabled = true
        manager.shouldResignOnTouchOutside = true
        manager.shouldToolbarUsesTextFieldTintColor = false
        manager.isEnableAutoToolbar = false

        SVProgressHUD.setDefaultMaskType(.black)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white

        window?.rootViewController = DDTabBarController()

        window?.makeKeyAndVisible()
        return true
    }
}
