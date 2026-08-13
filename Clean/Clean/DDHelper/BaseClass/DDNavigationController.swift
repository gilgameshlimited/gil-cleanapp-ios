import UIKit

class DDNavigationController: UINavigationController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
                
        if self.viewControllers.count > 0 {

            viewController.hidesBottomBarWhenPushed = true

        }
        
        super.pushViewController(viewController, animated: animated)
    }

    

}
