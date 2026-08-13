import UIKit

class DDPrivacyController: UIViewController {

    @IBOutlet weak var circleTextBGView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    
    @IBOutlet weak var secretAlbumLab: UILabel!
    
    @IBOutlet weak var secretAlbumSubLab: UILabel!
    
    @IBOutlet weak var secretContactsSubLab: UILabel!
    @IBOutlet weak var secretContactsLab: UILabel!
    let bigCircleWidth: CGFloat = SCREEN_WIDTH - 58.0 - 57.0
    let textCircleWidth: CGFloat = SCREEN_WIDTH - 58.0 - 57.0 - 22.0 - 22.0
    var bgLayer: CAShapeLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fd_prefersNavigationBarHidden = true
        configureSubviews()
        
        setupLocalization()

    }
    
    func setupLocalization() {
        
        self.secretAlbumLab.text = DDlocal("DDSecret_Album")
        self.secretAlbumSubLab.text = DDlocal("DDImport_your_private_photos_and_videos")
        self.secretContactsLab.text = DDlocal("DDSecret_Contacts")
        self.secretContactsSubLab.text = DDlocal("DDYour_Private_Contacts")
        
        self.secretAlbumLab.adjustsFontSizeToFitWidth = true
        self.secretAlbumSubLab.adjustsFontSizeToFitWidth = true
        self.secretContactsLab.adjustsFontSizeToFitWidth = true
        self.secretContactsSubLab.adjustsFontSizeToFitWidth = true



    }
    
    func configureSubviews() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        
//        81 (W - 57 - 58) 50 124/343*(W - 16 - 16) 16  124/343*(W - 16 - 16)  20
        let controlH = 124.0/343.0*(SCREEN_WIDTH - 16.0 - 16.0)
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 81.0 + SCREEN_WIDTH - 57.0 - 58.0 + 50.0 + controlH + 16.0 + controlH + 20.0)
        self.tableView.tableHeaderView = self.tableHeaderView
        self.tableView.tableFooterView = UIView()

        self.circleTextBGView.layer.cornerRadius = textCircleWidth / 2.0
        self.circleTextBGView.layer.masksToBounds = false
        self.circleTextBGView.clipsToBounds = false
          //获取中心点
        let position = CGPoint(x: textCircleWidth / 2.0, y: textCircleWidth / 2.0)
        let path = UIBezierPath(arcCenter: CGPoint(x: textCircleWidth / 2.0, y: textCircleWidth / 2.0), radius: textCircleWidth / 2.0, startAngle: -.pi / 2, endAngle: .pi * 3 / 2, clockwise: true)

        self.bgLayer = CAShapeLayer()
        self.bgLayer?.bounds = CGRectMake(0, 0, textCircleWidth, textCircleWidth)
        self.bgLayer?.position = position
        self.bgLayer?.lineCap = CAShapeLayerLineCap.round  //线闭合时的样式

        self.bgLayer?.strokeColor = UIColor(hexString: "#DCEAFF").cgColor  //轨迹颜色
        self.bgLayer?.fillColor = UIColor.clear.cgColor  //空心颜色
        self.bgLayer?.lineWidth = 20  //线的粗细
        self.bgLayer?.path = path.cgPath
        self.circleTextBGView.layer.addSublayer(self.bgLayer!)
        

    }
    
    
    
    @IBAction func secretAlbumClick(_ sender: Any) {
        self.navigationController?.pushViewController(DDSecretAlbumController(), animated: true)
    }
    @IBAction func secretContactsClick(_ sender: Any) {
        self.navigationController?.pushViewController(DDSecretContactsController(), animated: true)
    }

}
