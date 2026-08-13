import UIKit

class DDTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let tabArray = [
        ["title": DDlocal("DDClean"), "image": "tab_clean_normal", "selectedImg": "tab_clean_select", "controller": DDCleanController()],
        ["title": DDlocal("DDPrivacy"), "image": "tab_privacy_normal", "selectedImg": "tab_privacy_select", "controller": DDPrivacyController()],
        ["title": DDlocal("DDSettings"), "image": "tab_settings_normal", "selectedImg": "tab_settings_select", "controller": DDSettingsController()]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var arr: [DDNavigationController] = []
        
        self.tabArray.forEach { dic in
            
            let nav = getController(vc: dic["controller"] as! UIViewController, title: dic["title"] as! String, imgName: dic["image"] as! String, selImgName: dic["selectedImg"] as! String)
            arr.append(nav)
            
        }
        
        self.viewControllers = arr
        
        
        self.tabBar.backgroundColor = UIColor(hexString: "#FFFFFF")
        self.tabBar.barTintColor = UIColor(hexString: "#FFFFFF")
        self.tabBar.tintColor = UIColor(hexString: "#3863FF")
        self.tabBar.unselectedItemTintColor = UIColor(hexString: "#A8B2C4")


    }
    
    
    /**
     *  根据传入的参数创建控制器
     *
     *  @param cName   控制器类名
     *  @param title   导航和tabBar的标题
     *  @param imgName tabBar的图片
     *
     *  @return 控制器
     */
    func getController(vc: UIViewController, title: String, imgName: String, selImgName: String) -> DDNavigationController {
        
        //--设置tabBar的图片
        let normalimg = UIImage(named: imgName)
        let selectimg = UIImage(named: selImgName)
        
        vc.tabBarItem.title = title
        vc.tabBarItem.image = normalimg?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = selectimg?.withRenderingMode(.alwaysOriginal)

        
        //3.创建导航控制器
        let navController = DDNavigationController(rootViewController: vc)

        //4.返回导航控制器
        return navController


    }
    

}
