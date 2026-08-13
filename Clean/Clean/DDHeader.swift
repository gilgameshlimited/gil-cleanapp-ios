import Foundation
import UIKit

let kNotificationMoveDownThumbnailPlayView = "kNotificationMoveDownThumbnailPlayView"
let kNotificationMoveUpThumbnailPlayView = "kNotificationMoveUpThumbnailPlayView"

let DDThemeColor = UIColor(hexString: "#3863FF")!
let DDDefaultIcon = UIImage(named: "default_icon")
let DDSharePreferences = DDPreferences.shared

// MARK: - Layout
let DDAppDelegate = UIApplication.shared.delegate as? AppDelegate
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let DDHeightRatio = SCREEN_HEIGHT / 844.0
let DDWidthRatio = SCREEN_WIDTH / 390.0

let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
let kNavBarHeight = 44.0
let kNavBarAndStatusBarHeight = UIApplication.shared.statusBarFrame.size.height + 44.0

let kIs_iphone = UIDevice.current.userInterfaceIdiom == .phone
let kIs_iPhoneX = SCREEN_WIDTH >= 375.0 && SCREEN_HEIGHT >= 812.0 && kIs_iphone
let kTabBarHeight: CGFloat = kIs_iPhoneX ? 49.0 + 34.0 : 49.0
let kTopBarSafeHeight: CGFloat = kIs_iPhoneX ? 44.0 : 0
let kBottomSafeHeight: CGFloat = kIs_iPhoneX ? 34.0 : 0
let kTopBarDifHeight: CGFloat = kIs_iPhoneX ? 24.0 : 0
let kNavAndTabHeight: CGFloat = kNavBarAndStatusBarHeight + kTabBarHeight

let kA4Width = 595.0
let kA4Height = 842.0

// MARK: - Localized
func DDlocal(_ string: String) -> String {
    NSLocalizedString(string, comment: "")
}

// MARK: - Toast
func DDshowToast(_ string: String) {
    DispatchQueue.main.async {
        JRToast.show(withText: string, bottomOffset: SCREEN_HEIGHT / 2.0)
    }
}

func DDshowDelayToast(_ string: String, _ delay: CGFloat) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        JRToast.show(withText: string, bottomOffset: SCREEN_HEIGHT / 2.0)
    }
}
