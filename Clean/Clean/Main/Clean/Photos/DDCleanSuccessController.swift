import UIKit

class DDCleanSuccessController: UIViewController {

    @IBOutlet weak var saveTimeLab: UILabel!
    @IBOutlet weak var delSpaceLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var remindLab: UILabel!
    @IBOutlet weak var greatBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    var delArr: [PHAsset] = []
    var delSizeStr: String = ""
    var isVideo: Bool = false
    
    
    var handler: (() -> Void)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fd_prefersNavigationBarHidden = true
        self.fd_interactivePopDisabled = true
//        552.33 33.67 20
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 553 + 34 + 20)
        self.tableView.tableHeaderView = self.tableHeaderView
        self.tableView.tableFooterView = UIView()
        
//        Save 10 Minutes
//        using Clean up
        let saveTimeStr = DDlocal("DDSave") + " " + "\(self.getMinutes())" + " " + DDlocal("DDMinutes") + "\n\(DDlocal("DDusing_Clean_up"))"

        // 查找子字符串在主字符串中的范围
        if let range = saveTimeStr.range(of: "\(self.getMinutes())" + " " + DDlocal("DDMinutes")) {
            
            let timeAttributedString = NSMutableAttributedString(string: saveTimeStr)

            // 将 Swift 的 Range<String.Index> 转换为 NSRange
            let nsRange = NSRange(range, in: saveTimeStr)
            
            // 设置不同部分的属性，例如字体和颜色
            timeAttributedString.addAttribute(.foregroundColor, value: DDThemeColor, range: nsRange)
            timeAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .semibold), range: nsRange)  // 设置前两个字加粗

            
            self.saveTimeLab.attributedText = timeAttributedString

            
        }
        
        
        //You have deleted
        //            1 Photo (69KB)
        let spaceStr = DDlocal("DDYou_have_deleted") + "\n" + "\(self.delArr.count) \(self.isVideo ? DDlocal("DDVideos") : DDlocal("DDPhotos"))" + " " + self.delSizeStr
        
        // 查找子字符串在主字符串中的范围
        if let range = spaceStr.range(of: "\(self.delArr.count) \(self.isVideo ? DDlocal("DDVideos") : DDlocal("DDPhotos"))") {
            
            let spaceAttributedString = NSMutableAttributedString(string: spaceStr)
            
            // 将 Swift 的 Range<String.Index> 转换为 NSRange
            let nsRange = NSRange(range, in: spaceStr)
            
            // 设置不同部分的属性，例如字体和颜色
            spaceAttributedString.addAttribute(.foregroundColor, value: DDThemeColor, range: nsRange)
            spaceAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .semibold), range: nsRange)  // 设置前两个字加粗
            
            
            self.delSpaceLab.attributedText = spaceAttributedString
            
            
        }
        
        
        let remindStr = "\(DDlocal("DDEmpty_Recently_Deleted_Album_on_your")) \(self.delSizeStr) \(DDlocal("DDspace"))."
        // 查找子字符串在主字符串中的范围
        if let range = remindStr.range(of: self.delSizeStr) {
            
            let remindAttributedString = NSMutableAttributedString(string: remindStr)
            
            // 将 Swift 的 Range<String.Index> 转换为 NSRange
            let nsRange = NSRange(range, in: remindStr)
            
            // 设置不同部分的属性，例如字体和颜色
            remindAttributedString.addAttribute(.foregroundColor, value: UIColor.black, range: nsRange)
            
            self.remindLab.attributedText = remindAttributedString
            
            
        }
        

        self.titleLab.text = DDlocal("DDCongratulations")
        self.greatBtn.setTitle(DDlocal("DDGreat"), for: .normal)
        
        self.titleLab.adjustsFontSizeToFitWidth = true
        self.greatBtn.titleLabel?.adjustsFontSizeToFitWidth = true



        
    }

    
    func getMinutes() -> Int {
        
        let count = self.delArr.count
        let minutes = count/(self.isVideo ? 2 : 5)
        if minutes < 1 {
            return 1
        } else if minutes > 10 {
            return 10
        } else {
            return minutes
        }
        
    }
    
    
    @IBAction func greatClick(_ sender: Any) {
        
        if let handler = handler {
            handler()
        }
        if let vc = self.navigationController?.viewControllers[1] as? UIViewController {
            self.navigationController?.popToViewController(vc, animated: true)
        }
        
    }
    


}
