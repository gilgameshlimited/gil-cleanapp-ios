import UIKit
import Contacts

class DDCleanController: UIViewController {

    @IBOutlet weak var circleTextBGView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var memoryRatioLab: UILabel!
    @IBOutlet weak var memoryLab: UILabel!
    
    let bigCircleWidth: CGFloat = SCREEN_WIDTH - 58.0 - 57.0
    let textCircleWidth: CGFloat = SCREEN_WIDTH - 58.0 - 57.0 - 22.0 - 22.0
    var bgLayer: CAShapeLayer?
    var dynamicLayer: CAShapeLayer?
    var ratio: Double = 0

    @IBOutlet weak var cleanBtn: UIButton!
    @IBOutlet weak var oldEventsLab: UILabel!
    @IBOutlet weak var duplicateContactsLab: UILabel!
    @IBOutlet weak var videosSpaceLab: UILabel!
    @IBOutlet weak var photosSpaceLab: UILabel!
    
    @IBOutlet weak var calendarLab: UILabel!
    
    @IBOutlet weak var videosLab: UILabel!
    @IBOutlet weak var photosLab: UILabel!
    @IBOutlet weak var contactsLab: UILabel!
    var calendarDic: [Int: [DDCalendarEvent]] = [:]
    var allContacts: [CNContact] = []
    var duplicateContacts: [[CNContact]] = []
    var allPhotos: [PHAsset] = []
    var allVideos: [PHAsset] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fd_prefersNavigationBarHidden = true
        
        configureSubviews()
        
        self.setupLocalization()
        
    }
    
    func setupLocalization() {
        
        
        self.calendarLab.text = DDlocal("DDCalendar")
        self.contactsLab.text = DDlocal("DDContacts")
        self.photosLab.text = DDlocal("DDPhotos")
        self.videosLab.text = DDlocal("DDVideos")
        
        self.oldEventsLab.text = "0 \(DDlocal("DDold_event_s"))"
        self.duplicateContactsLab.text = "0 \(DDlocal("DDduplicate_s"))"
        self.photosSpaceLab.text = "0 \(DDlocal("DDPhotos")) 0.0KB"
        self.videosSpaceLab.text = "0 \(DDlocal("DDVideos")) 0.0KB"

        self.cleanBtn.setTitle(" \(DDlocal("DDBIGCLEAN"))", for: .normal)

        
        self.calendarLab.adjustsFontSizeToFitWidth = true
        self.contactsLab.adjustsFontSizeToFitWidth = true
        self.photosLab.adjustsFontSizeToFitWidth = true
        self.videosLab.adjustsFontSizeToFitWidth = true
        
        self.oldEventsLab.adjustsFontSizeToFitWidth = true
        self.duplicateContactsLab.adjustsFontSizeToFitWidth = true
        self.photosSpaceLab.adjustsFontSizeToFitWidth = true
        self.videosSpaceLab.adjustsFontSizeToFitWidth = true
        
        self.cleanBtn.titleLabel?.adjustsFontSizeToFitWidth = true

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateAllCategoryData()
    }
    
    func updateAllCategoryData() {
    
        if let space = getDeviceStorageInfo() {
            
            self.memoryLab.text = String(format: "%.1fGB of %.1fGB\n\(DDlocal("DDavailable"))", space.freeSpace, space.totalSpace)
            self.ratio = space.usedSpace/space.totalSpace
            self.memoryRatioLab.text = String(format: "%.0f", ratio*100)
            self.animateStrokeEnd(to: self.ratio, duration: 0.5, delay: 1.0)

        }
        
        fetchCalendarEvents()
        fetchDuplicatesContacts()
        fetchAllPhotos()
        fetchAllVideos()
        
    }
    
    func fetchCalendarEvents() {
        
        DDCalendarManager.shared.checkCalendarAuthorizationStatus { success in
            
            if success {
                
                DDCalendarManager.shared.fetchEventsForLastThreeYears { calendarDic in
                    var tempArr: [DDCalendarEvent] = []
                    self.calendarDic = calendarDic
                    for key in self.calendarDic.keys {
                        if let arr = self.calendarDic[key] {
                            tempArr.append(contentsOf: arr)
                        }
                    }
                    
                    self.oldEventsLab.text = "\(tempArr.count) \(DDlocal("DDold_event_s"))"
                }
                
            }
            
        }
        
    }
    
    func fetchDuplicatesContacts() {
        
        DDSharedContactsManager.checkContactAuthorizationStatus { success in
            
            if success {
                
                DispatchQueue.global().async {
                    
                    self.allContacts = DDContactsManager.shared.fetchAllContacts()
                    self.duplicateContacts = DDSharedContactsManager.findDuplicateNameContacts(contacts: self.allContacts)
                                        
                    DispatchQueue.main.async {

                        self.duplicateContactsLab.text = "\(self.duplicateContacts.count) \(DDlocal("DDduplicate_s"))"

                    }
                    
                }
                
            }
            
        }
    }
    
    func fetchAllPhotos() {
                
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
                    self.allPhotos = DDPhotosManager.shared.fetchAllPhotos()
                    DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: self.allPhotos) { sizeStr in
                        
                        DispatchQueue.main.async {
                            
                            self.photosSpaceLab.text = "\(self.allPhotos.count) \(DDlocal("DDPhotos")) \(sizeStr)"
                            
                        }
                        
                    }

                }
                
            }
        }
        

    }
    
    func fetchAllVideos() {
                
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
                    DDPhotosManager.shared.fetchAllVideos(completion: { assets in
                        DDPhotosManager.shared.getVideoPHAssetsTotalFileSize(assets: assets) { sizeStr in
                            
                            DispatchQueue.main.async {
                                
                                self.allVideos = assets
                                
                                self.videosSpaceLab.text = "\(self.allVideos.count) \(DDlocal("DDVideos")) \(sizeStr)"
                                
                            }
                        }
                    })


                }
                
            }
        }
        

    }

    

    
    @IBAction func calendarClick(_ sender: Any) {
        let vc = DDCalendarController()
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func contactsClick(_ sender: Any) {
        
        let vc = DDContactsController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func photosClick(_ sender: Any) {
        
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                let vc = DDPhotosController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                DDshowToast(DDlocal("DDNo_permission_to_use_the_album"))
            }
        }
        
    }
    @IBAction func videoClick(_ sender: Any) {
        
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                let vc = DDVideosController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                DDshowToast(DDlocal("DDNo_permission_to_use_the_album"))
            }
        }
        
    }
    

    @IBAction func cleanClick(_ sender: Any) {
        let vc = DDCleanContentController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureSubviews() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        
//        81 (W - 57 - 58) 24 60 24  124/164*((W - 15 - 16 - 16)/2) 16 124/164*((W - 15 - 16 - 16)/2) 20
        let controlH = 124.0/164.0*(SCREEN_WIDTH - 15.0 - 16.0 - 16.0)/2.0
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 81.0 + SCREEN_WIDTH - 57.0 - 58.0 + 24.0 + 60.0 + 24.0 + controlH + 16.0 + controlH + 20.0)
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
        
//    #E9E9E7   #231F18

        self.dynamicLayer = CAShapeLayer()
        self.dynamicLayer?.bounds = CGRectMake(0, 0, textCircleWidth, textCircleWidth)
        self.dynamicLayer?.position = position
        self.dynamicLayer?.strokeColor = UIColor(hexString: "#597DFF").cgColor
        

        self.dynamicLayer?.fillColor = UIColor.clear.cgColor
        self.dynamicLayer?.lineCap = CAShapeLayerLineCap.round
        self.dynamicLayer?.lineWidth = 20
        self.dynamicLayer?.path = path.cgPath
        self.dynamicLayer?.strokeStart = 0
        self.dynamicLayer?.strokeEnd = 0
        self.circleTextBGView.layer.addSublayer(self.dynamicLayer!)
        

        

    }
    

    func animateStrokeEnd(to ratio: CGFloat, duration: CFTimeInterval, delay: CFTimeInterval) {
        // 创建 CABasicAnimation 对象
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        // 设置动画的开始值和结束值
        animation.fromValue = self.dynamicLayer?.strokeEnd // 动画起始值为当前 strokeEnd
        animation.toValue = ratio                          // 动画结束值为传入的 ratio

        // 动画时长
        animation.duration = duration

        // 设置延迟开始时间
        animation.beginTime = CACurrentMediaTime() + delay

        // 动画结束后保持最终状态
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        // 添加动画到图层
        self.dynamicLayer?.add(animation, forKey: "strokeEndAnimation")
        
        // 更新动态层的 strokeEnd 属性为目标值，以便动画完成后图层保持新值
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 1.0) {
            self.dynamicLayer?.strokeEnd = ratio
            self.dynamicLayer?.removeAnimation(forKey: "strokeEndAnimation")
        }
    }


    
    func getDeviceStorageInfo() -> (totalSpace: Double, freeSpace: Double, usedSpace: Double)? {
        do {
            let fileURL = URL(fileURLWithPath: NSHomeDirectory() as String)
            let values = try fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey, .volumeAvailableCapacityForImportantUsageKey])
            
            if let totalSpace = values.volumeTotalCapacity,
               let freeSpace = values.volumeAvailableCapacityForImportantUsage {
                
                // 将存储空间转换为 Double 类型的 GB 单位
                let totalSpaceGB = Double(totalSpace) / 1000.0 / 1000.0 / 1000.0
                let freeSpaceGB = Double(freeSpace) / 1000.0 / 1000.0 / 1000.0
                let usedSpaceGB = totalSpaceGB - freeSpaceGB
                
                return (totalSpace: totalSpaceGB, freeSpace: freeSpaceGB, usedSpace: usedSpaceGB)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }




}
