import UIKit

class DDAllCleanSuccessController: UIViewController {

    @IBOutlet weak var saveTimeLab: UILabel!
    @IBOutlet weak var delSpaceLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var remindLab: UILabel!
    @IBOutlet weak var greatBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    
    var totalFileSize: Double = 0.0
    var photosCount: Int = 0
    var videosCount: Int = 0
    var contactsCount: Int = 0
    var eventsCount: Int = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fd_prefersNavigationBarHidden = true
        self.fd_interactivePopDisabled = true
        
        configureSubviews()
        
        setupLocalization()
    
    }
    
    func setupLocalization() {
        self.titleLab.text = DDlocal("DDCongratulations")
        self.greatBtn.setTitle(DDlocal("DDGreat"), for: .normal)
        
        self.titleLab.adjustsFontSizeToFitWidth = true
        self.greatBtn.titleLabel?.adjustsFontSizeToFitWidth = true

    }
    
    func configureSubviews() {

        let spaceStr = String(format: "%@", self.totalFileSize > 0 ? "\n(\(self.totalFileSize.getFileSizeStr()))" : "")
        
        let countStr = "\(self.photosCount) \(DDlocal("DDPhotos")),\(self.videosCount) \(DDlocal("DDVideos"))\n\(self.contactsCount) \(DDlocal("DDContacts")),\(self.eventsCount) \(DDlocal("DDEvents"))"

        let deletedTotalStr = "\(DDlocal("DDYou_have_deleted"))\n" + countStr + spaceStr
        
        // 查找子字符串在主字符串中的范围
        if let range = deletedTotalStr.range(of: countStr) {
            
            let attributedString = NSMutableAttributedString(string: deletedTotalStr)

            // 将 Swift 的 Range<String.Index> 转换为 NSRange
            let nsRange = NSRange(range, in: deletedTotalStr)
            
            // 设置不同部分的属性，例如字体和颜色
            attributedString.addAttribute(.foregroundColor, value: DDThemeColor, range: nsRange)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .semibold), range: nsRange)  // 设置前两个字加粗

            self.delSpaceLab.attributedText = attributedString

            
        }
        
//        Save 10 Minutes
//        using Clean up
        let timeStr = "\(self.getMinutes()) \(DDlocal("DDMinutes"))"
        let saveTotalStr = "\(DDlocal("DDSave")) \(timeStr)\n\(DDlocal("DDusing_Clean_up"))"
        
        // 查找子字符串在主字符串中的范围
        if let range = saveTotalStr.range(of: timeStr) {
            
            let attributedString = NSMutableAttributedString(string: saveTotalStr)

            // 将 Swift 的 Range<String.Index> 转换为 NSRange
            let nsRange = NSRange(range, in: saveTotalStr)
            
            // 设置不同部分的属性，例如字体和颜色
            attributedString.addAttribute(.foregroundColor, value: DDThemeColor, range: nsRange)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .semibold), range: nsRange)  // 设置前两个字加粗

            self.saveTimeLab.attributedText = attributedString

            
        }
        
        
        if self.totalFileSize > 0 {
            self.remindLab.isHidden = false
            let spaceStr = "\(self.totalFileSize.getFileSizeStr())"
            let remindTotalStr = "\(DDlocal("DDEmpty_Recently_Deleted_Album_on_your")) \(spaceStr) \(DDlocal("DDspace"))."
            // 查找子字符串在主字符串中的范围
            if let range = remindTotalStr.range(of: spaceStr) {
                
                let remindAttributedString = NSMutableAttributedString(string: remindTotalStr)
                
                // 将 Swift 的 Range<String.Index> 转换为 NSRange
                let nsRange = NSRange(range, in: remindTotalStr)
                
                // 设置不同部分的属性，例如字体和颜色
                remindAttributedString.addAttribute(.foregroundColor, value: UIColor.black, range: nsRange)
                 
                self.remindLab.attributedText = remindAttributedString
                
                
            }
        } else {
            self.remindLab.isHidden = true
        }
        
        
        
        
//        87 200 36 54 DELH 40 41 54 34 20
        let delH = NSString.getTextHeight(withText: deletedTotalStr, width: SCREEN_WIDTH - 75.0 - 75.0 - 62.0, font: UIFont.systemFont(ofSize: 18, weight: .semibold))
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 87.0 + 200.0 + 36.0 + 54.0 + delH + 40.0 + 41.0 + 54.0 + 34.0 + 20.0)
        self.tableView.tableHeaderView = self.tableHeaderView
        self.tableView.tableFooterView = UIView()

         
    }

    
    func getMinutes() -> Int {
        
        let totalCount = self.photosCount + self.videosCount + self.contactsCount + self.eventsCount
        let minutes = Double(totalCount) * 0.5
        return minutes < 1 ? 1 : Int(minutes)
        
    }
    
    
    @IBAction func greatClick(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: false)

    }
    


}
