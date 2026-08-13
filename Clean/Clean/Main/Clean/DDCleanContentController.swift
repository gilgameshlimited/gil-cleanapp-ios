import UIKit
import Contacts

class DDCleanContentController: UIViewController {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var nodataView: UIView!
    
    @IBOutlet var tableHeaderView: UIView!
    
    @IBOutlet weak var photosTitleLab: UILabel!
    @IBOutlet weak var photosSimilarLab: UILabel!
    @IBOutlet weak var photosSimilarSpaceLab: UILabel!
    @IBOutlet weak var photosSimilarNumLab: UILabel!
    @IBOutlet weak var photosSimilarSelBtn: UIButton!
    @IBOutlet weak var photosDuplicateLab: UILabel!
    @IBOutlet weak var photosDuplicateSpaceLab: UILabel!
    @IBOutlet weak var photosDuplicateNumLab: UILabel!
    @IBOutlet weak var photosDuplicateSelBtn: UIButton!
    @IBOutlet weak var photosShotsLab: UILabel!
    @IBOutlet weak var photosShotsSpaceLab: UILabel!
    @IBOutlet weak var photosShotsNumLab: UILabel!
    @IBOutlet weak var photosShotsSelBtn: UIButton!
    @IBOutlet weak var photosBlurryLab: UILabel!
    @IBOutlet weak var photosBlurrySpaceLab: UILabel!
    @IBOutlet weak var photosBlurryNumLab: UILabel!
    @IBOutlet weak var photosBlurrySelBtn: UIButton!
    
    @IBOutlet weak var videosTitleLab: UILabel!
    @IBOutlet weak var videosDuplicateLab: UILabel!
    @IBOutlet weak var videosDuplicateSpaceLab: UILabel!
    @IBOutlet weak var videosDuplicateNumLab: UILabel!
    @IBOutlet weak var videosDuplicateSelBtn: UIButton!
    
 
    @IBOutlet weak var videosScreenLab: UILabel!
    @IBOutlet weak var videosScreenSpaceLab: UILabel!
    @IBOutlet weak var videosScreenNumLab: UILabel!
    @IBOutlet weak var videosScreenSelBtn: UIButton!
    
    @IBOutlet weak var videosShortLab: UILabel!
    @IBOutlet weak var videosShortSpaceLab: UILabel!
    @IBOutlet weak var videosShortNumLab: UILabel!
    @IBOutlet weak var videosShortSelBtn: UIButton!
    
    
    @IBOutlet weak var contactTitleLab: UILabel!
    
    @IBOutlet weak var contactsDuplicateLab: UILabel!
    @IBOutlet weak var contactsDuplicateSpaceLab: UILabel!
    @IBOutlet weak var contactsDuplicateNumLab: UILabel!
    @IBOutlet weak var contactsDuplicateSelBtn: UIButton!
    
    @IBOutlet weak var contactsIncompleteLab: UILabel!
    @IBOutlet weak var contactsIncompleteSpaceLab: UILabel!
    @IBOutlet weak var contactsIncompleteNumLab: UILabel!
    @IBOutlet weak var contactsIncompleteSelBtn: UIButton!
    
    
    @IBOutlet weak var eventsTitleLab: UILabel!
    @IBOutlet weak var eventsPastLab: UILabel!
    @IBOutlet weak var eventsPastSpaceLab: UILabel!
    @IBOutlet weak var eventsPastNumLab: UILabel!
    @IBOutlet weak var eventsPastSelBtn: UIButton!

    @IBOutlet weak var nodataLab: UILabel!
    @IBOutlet weak var cleanItemsBtn: UIButton!
    var photosSimilarOriginalArr: [[PHAsset]] = []
    var photosSimilarArr: [PHAsset] = []
    
    var photosDuplicateOriginalArr: [[PHAsset]] = []
    var photosDuplicateArr: [PHAsset] = []

    var photosScreenshotsArr: [PHAsset] = []

    var photosBlurryArr: [PHAsset] = []
    
    var videosDuplicateOriginalArr: [[PHAsset]] = []
    var videosDuplicateArr: [PHAsset] = []

    var videosScreenArr: [PHAsset] = []
    
    var videosShortArr: [PHAsset] = []
    
    var contactsDuplicateArr: [[CNContact]] = []
    var contactsIncompleteArr: [CNContact] = []

    var eventsPastArr: [DDCalendarEvent] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true
        //723 54 20
        self.nodataView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarAndStatusBarHeight - kBottomSafeHeight)
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 723.0 + 54.0 + 20.0)
        self.tableView.tableHeaderView = self.tableHeaderView
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 51 + 11, right: 0)
        self.tableView.tableFooterView = UIView()
        
        setupLocalization()
        
        self.updateCategorySelBtnStatusWithData()

        updateAllCategoryData()

    }
    
    func setupLocalization() {
        
        self.titleLab.text = DDlocal("DDCleaning_Result")
        self.photosTitleLab.text = DDlocal("DDPhotos")
        self.videosTitleLab.text = DDlocal("DDVideos")
        self.contactTitleLab.text = DDlocal("DDContacts")
        self.eventsTitleLab.text = DDlocal("DDEvents")

        self.photosSimilarLab.text = DDlocal("DDSimilar")
        self.photosDuplicateLab.text = DDlocal("DDDuplicate")
        self.photosShotsLab.text = DDlocal("DDScreenshots")
        self.photosBlurryLab.text = DDlocal("DDBlurry")
        
        self.videosDuplicateLab.text = DDlocal("DDDuplicate")
        self.videosScreenLab.text = DDlocal("DDScreen_Recordings")
        self.videosShortLab.text = DDlocal("DDShort_Recordings")
        
        self.contactsDuplicateLab.text = DDlocal("DDDuplicate")
        self.contactsIncompleteLab.text = DDlocal("DDIncomplete")
        self.eventsPastLab.text = DDlocal("DDPast")
        self.nodataLab.text = DDlocal("DDNothing_to_clean_here")

        
        self.titleLab.adjustsFontSizeToFitWidth = true
        self.photosTitleLab.adjustsFontSizeToFitWidth = true
        self.videosTitleLab.adjustsFontSizeToFitWidth = true
        self.contactTitleLab.adjustsFontSizeToFitWidth = true
        self.eventsTitleLab.adjustsFontSizeToFitWidth = true

        self.photosSimilarLab.adjustsFontSizeToFitWidth = true
        self.photosDuplicateLab.adjustsFontSizeToFitWidth = true
        self.photosShotsLab.adjustsFontSizeToFitWidth = true
        self.photosBlurryLab.adjustsFontSizeToFitWidth = true
        
        self.videosDuplicateLab.adjustsFontSizeToFitWidth = true
        self.videosScreenLab.adjustsFontSizeToFitWidth = true
        self.videosShortLab.adjustsFontSizeToFitWidth = true
        
        self.contactsDuplicateLab.adjustsFontSizeToFitWidth = true
        self.contactsIncompleteLab.adjustsFontSizeToFitWidth = true
        self.eventsPastLab.adjustsFontSizeToFitWidth = true
        self.nodataLab.adjustsFontSizeToFitWidth = true

    }
    
    func updateAllCategoryData() {
        
        SVProgressHUD.show()
        
        self.cleanItemsBtn.backgroundColor = UIColor(hexString: "#3863FF", alpha: 0.5)
        self.cleanItemsBtn.setTitle("\(DDlocal("DDClean")) 0 \(DDlocal("DDitems"))", for: .normal)
        
        
        
        let disGroup = DispatchGroup()
        
        disGroup.enter()
        fetchPhotosSimilar { success in
            disGroup.leave()
        }
        
        disGroup.enter()
        fetchPhotosDuplicate { success in
            disGroup.leave()
        }
        
        disGroup.enter()
        fetchPhotosScreenshots { success in
            disGroup.leave()
        }
        
        disGroup.enter()
        fetchPhotosBlurry { success in
            disGroup.leave()
        }
        
        disGroup.enter()
        fetchVideosDuplicate { success in
            disGroup.leave()
        }
        
        disGroup.enter()
        fetchVideosScreenRecordings { success in
            disGroup.leave()
        }
        
        disGroup.enter()
        fetchVideosShortRecordings { success in
            disGroup.leave()
        }
        
        disGroup.enter()
        fetchContactsDuplicateAndIncomplete { success in
            disGroup.leave()
        }
        
        disGroup.enter()
        fetchEventsPast { success in
            disGroup.leave()
        }
        
        
        disGroup.notify(queue: .main) {
            
            let itemsCount = self.photosSimilarArr.count + self.photosDuplicateArr.count + self.photosScreenshotsArr.count + self.photosBlurryArr.count + self.videosDuplicateArr.count + self.videosScreenArr.count + self.videosShortArr.count + self.contactsDuplicateArr.count + self.contactsIncompleteArr.count + self.eventsPastArr.count
            
            if itemsCount < 1 {
                self.cleanItemsBtn.isHidden = true

                self.tableView.tableHeaderView = self.nodataView
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            
            self.updateCategorySelBtnStatusWithData()
            
            self.cleanItemsBtn.backgroundColor = UIColor(hexString: "#3863FF")
            self.cleanItemsBtn.setTitle("\(DDlocal("DDClean")) \(itemsCount) \(DDlocal("DDitems"))", for: .normal)

            
            SVProgressHUD.dismiss()
        }
        
    }
    
    func updateCategorySelBtnStatusWithData() {
        
        
        self.photosSimilarSelBtn.isSelected = self.photosSimilarArr.count > 0
        self.photosDuplicateSelBtn.isSelected = self.photosDuplicateArr.count > 0
        self.photosShotsSelBtn.isSelected = self.photosScreenshotsArr.count > 0
        self.photosBlurrySelBtn.isSelected = self.photosBlurryArr.count > 0
        
        self.videosDuplicateSelBtn.isSelected = self.videosDuplicateArr.count > 0
        self.videosScreenSelBtn.isSelected = self.videosScreenArr.count > 0
        self.videosShortSelBtn.isSelected = self.videosShortArr.count > 0
        
        self.contactsDuplicateSelBtn.isSelected = self.contactsDuplicateArr.count > 0
        self.contactsIncompleteSelBtn.isSelected = self.contactsIncompleteArr.count > 0
        
        self.eventsPastSelBtn.isSelected = self.eventsPastArr.count > 0
        
        
    }
    
    func updateCleanItemsBtn() {
        
        let photosSimilarCount = self.photosSimilarSelBtn.isSelected ? self.photosSimilarArr.count : 0
        let photosDuplicateCount = self.photosDuplicateSelBtn.isSelected ? self.photosDuplicateArr.count : 0
        let photosScreenshotsCount = self.photosShotsSelBtn.isSelected ? self.photosScreenshotsArr.count : 0
        let photosBlurryCount = self.photosBlurrySelBtn.isSelected ? self.photosBlurryArr.count : 0
        let videosDuplicateCount = self.videosDuplicateSelBtn.isSelected ? self.videosDuplicateArr.count : 0
        let videosScreenCount = self.videosScreenSelBtn.isSelected ? self.videosScreenArr.count : 0
        let videosShortCount = self.videosShortSelBtn.isSelected ? self.videosShortArr.count : 0
        let contactsDuplicateCount = self.contactsDuplicateSelBtn.isSelected ? self.contactsDuplicateArr.count : 0
        let contactsIncompleteCount = self.contactsIncompleteSelBtn.isSelected ? self.contactsIncompleteArr.count : 0
        let eventsPastCount = self.eventsPastSelBtn.isSelected ? self.eventsPastArr.count : 0

        
        
        let itemsCount = photosSimilarCount + photosDuplicateCount + photosScreenshotsCount + photosBlurryCount + videosDuplicateCount + videosScreenCount + videosShortCount + contactsDuplicateCount + contactsIncompleteCount + eventsPastCount

        
        self.cleanItemsBtn.setTitle("\(DDlocal("DDClean")) \(itemsCount) \(DDlocal("DDitems"))", for: .normal)

        if itemsCount > 0 {
            self.cleanItemsBtn.backgroundColor = UIColor(hexString: "#3863FF")
        } else {
            self.cleanItemsBtn.backgroundColor = UIColor(hexString: "#3863FF", alpha: 0.5)
        }
        
    }
    
    func fetchPhotosSimilar(handler: @escaping (_ success: Bool) -> Void) {
        
        self.photosSimilarOriginalArr = []
        self.photosSimilarArr = []

        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
                    
                    if let tempArr = AMPhotoManager.fectchSimilarArray() as? [[PHAsset]] {
                        self.photosSimilarOriginalArr = tempArr
                        for arr in self.photosSimilarOriginalArr {
                            
                            for asset in arr {
                                self.photosSimilarArr.append(asset)
                            }

                        }
                        
                        DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: self.photosSimilarArr) { sizeStr in
                            
                            handler(true)

                            DispatchQueue.main.async {
                                
                                self.photosSimilarSpaceLab.text = sizeStr
                                self.photosSimilarNumLab.text = "\(self.photosSimilarArr.count)"
                                

                            }

                        }

                    } else {
                        
                        handler(false)

                    }
              
                }
                
            } else {
                
                handler(false)
                
            }
        }

    }
    
    func fetchPhotosDuplicate(handler: @escaping (_ success: Bool) -> Void) {
        
        self.photosDuplicateOriginalArr = []
        self.photosDuplicateArr = []
        
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
                    
                    DDPhotosManager.shared.findDuplicatePhotos { assets in
                        
                        self.photosDuplicateOriginalArr = assets
                        
                        for arr in self.photosDuplicateOriginalArr {
                            
                            for asset in arr {
                                self.photosDuplicateArr.append(asset)
                            }

                        }
                        
                        DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: self.photosDuplicateArr) { sizeStr in
                            
                            handler(true)
                            
                            DispatchQueue.main.async {
                                
                                self.photosDuplicateSpaceLab.text = sizeStr
                                self.photosDuplicateNumLab.text = "\(self.photosDuplicateArr.count)"

                            }

                        }
                        
                    }
                }
                
            } else {
                handler(false)
            }
        }
        
        
    }
    
    func fetchPhotosScreenshots(handler: @escaping (_ success: Bool) -> Void) {
        
        self.photosScreenshotsArr = []
        
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
                    
                    self.photosScreenshotsArr = DDPhotosManager.shared.fetchScreenshotPhotos()
                    
                    DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: self.photosScreenshotsArr) { sizeStr in
                        handler(true)
                        DispatchQueue.main.async {
                            
                            self.photosShotsSpaceLab.text = sizeStr
                            self.photosShotsNumLab.text = "\(self.photosScreenshotsArr.count)"

                        }

                    }

                }
                
               
                
            } else {
                handler(false)
            }
        }
        

    }
    
    
    func fetchPhotosBlurry(handler: @escaping (_ success: Bool) -> Void) {
        
        self.photosBlurryArr = []
        
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
                    
                    DDPhotosManager.shared.fetchBlurredPhotos { assets in
                        
                        self.photosBlurryArr = assets
                        
                        DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: self.photosBlurryArr) { sizeStr in
                            
                            handler(true)
                            
                            DispatchQueue.main.async {
                                
                                self.photosBlurrySpaceLab.text = sizeStr
                                self.photosBlurryNumLab.text = "\(self.photosBlurryArr.count)"

                            }

                        }
                        
                        
                    }

                }
                
               
                
            } else {
                handler(false)
            }
        }
        

    }
    
    
    func fetchVideosDuplicate(handler: @escaping (_ success: Bool) -> Void) {
        
        self.videosDuplicateOriginalArr = []
        self.videosDuplicateArr = []
        
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
                    
                    DDPhotosManager.shared.findDuplicateVideos { assets in
                        
                        self.videosDuplicateOriginalArr = assets
                        
                        for arr in self.videosDuplicateOriginalArr {
                            
                            for asset in arr {
                                self.videosDuplicateArr.append(asset)
                            }

                        }
                        
                        
                        DDPhotosManager.shared.getVideoPHAssetsTotalFileSize(assets: self.videosDuplicateArr) { sizeStr in

                            handler(true)
                            
                            DispatchQueue.main.async {
                                
                                self.videosDuplicateSpaceLab.text = sizeStr
                                self.videosDuplicateNumLab.text = "\(self.videosDuplicateArr.count)"

                            }

                        }
        
                        
                        
                    }
                }
                
            } else {
                handler(false)
            }
        }
        
        
    }


    func fetchVideosScreenRecordings(handler: @escaping (_ success: Bool) -> Void) {
        
        self.videosScreenArr = []
        
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
          
                    DDPhotosManager.shared.fetchScreenRecordingVideos { assets in
                        
                        self.videosScreenArr = assets
                        
                        
                        DDPhotosManager.shared.getVideoPHAssetsTotalFileSize(assets: self.videosScreenArr) { sizeStr in

                            handler(true)
                            
                            DispatchQueue.main.async {
                                
                                self.videosScreenSpaceLab.text = sizeStr
                                self.videosScreenNumLab.text = "\(self.videosScreenArr.count)"

                            }

                        }

                        
                    }
                }
                
            } else {
                handler(false)
            }
        }
        
        
    }
    
    func fetchVideosShortRecordings(handler: @escaping (_ success: Bool) -> Void) {
        
        self.videosShortArr = []
        
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
         
                    DDPhotosManager.shared.fetchShortVideos { assets in
                        
                        self.videosShortArr = assets
                        
                        DDPhotosManager.shared.getVideoPHAssetsTotalFileSize(assets: self.videosShortArr) { sizeStr in

                            handler(true)
                            
                            DispatchQueue.main.async {
                                
                                self.videosShortSpaceLab.text = sizeStr
                                self.videosShortNumLab.text = "\(self.videosShortArr.count)"

                            }

                        }
                        
                        
                        
                    }
                }
                
            } else {
                handler(false)
            }
        }
        
        
    }
    
    func fetchContactsDuplicateAndIncomplete(handler: @escaping (_ success: Bool) -> Void) {
        
        self.contactsDuplicateArr = []
        self.contactsIncompleteArr = []
        
        DDSharedContactsManager.checkContactAuthorizationStatus { success in
            
            if success {
                
                DispatchQueue.global().async {
                    
                    let allContacts = DDContactsManager.shared.fetchAllContacts()
                    self.contactsDuplicateArr = DDSharedContactsManager.findDuplicateNameContacts(contacts: allContacts)
                    self.contactsIncompleteArr = DDSharedContactsManager.filterIncompleteContacts(contacts: allContacts)
                    
                    handler(true)
                                        
                    DispatchQueue.main.async {
                        self.contactsDuplicateNumLab.text = "\(self.contactsDuplicateArr.count)"
                        self.contactsIncompleteNumLab.text = "\(self.contactsIncompleteArr.count)"
                    }
                    
                }
                
            } else {
                
                handler(false)
            }
            
        }
        
        
    }

    func fetchEventsPast(handler: @escaping (_ success: Bool) -> Void) {
        
        DDCalendarManager.shared.checkCalendarAuthorizationStatus { success in
            
            if success {
                
                DispatchQueue.global().async {
                    
                    DDCalendarManager.shared.fetchEventsForLastThreeYears { calendarDic in
                        
                        var tempArr: [DDCalendarEvent] = []
                        
                        let keys = calendarDic.keys
                        
                        for key in keys {
                            
                            if let arr = calendarDic[key] {
                                tempArr.append(contentsOf: arr)
                            }
                        
                        }
                        
                        self.eventsPastArr = tempArr
                        
                        handler(true)
                        
                        DispatchQueue.main.async {
                            self.eventsPastNumLab.text = "\(self.eventsPastArr.count)"
                        }
                        
                        
                    }
                    
                }
                
                
            } else {
                handler(false)
            }
            
        }
        
        
    }


  
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    @IBAction func photosSimilarClick(_ sender: Any) {
        
        let vc = DDSimilarPhotosController()
        
        vc.originalSimilarArr = self.photosSimilarOriginalArr
        
        vc.handler = {
            self.updateAllCategoryData()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    

    
    @IBAction func photosSimilarSleBtnClick(_ sender: Any) {
     
        self.photosSimilarSelBtn.isSelected = !self.photosSimilarSelBtn.isSelected
        
        updateCleanItemsBtn()
        
    }
    
    @IBAction func photosDuplicateClick(_ sender: Any) {
        
        let vc = DDSimilarPhotosController()
        vc.isDuplicate = true
        vc.originalSimilarArr = self.photosDuplicateOriginalArr
        
        vc.handler = {
            self.updateAllCategoryData()
        }
    
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func photosDuplicateSelBtnClick(_ sender: Any) {
        
        self.photosDuplicateSelBtn.isSelected = !self.photosDuplicateSelBtn.isSelected
        updateCleanItemsBtn()

    }
    
    @IBAction func photosScreenClick(_ sender: Any) {
        
        let vc = DDScreenshotsPhotosController()
        vc.screenshotsArr = self.photosScreenshotsArr
        vc.isBlur = false
        vc.handler = {
            self.updateAllCategoryData()

        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func photosScreenSelBtnClick(_ sender: Any) {
        
        self.photosShotsSelBtn.isSelected = !self.photosShotsSelBtn.isSelected
        updateCleanItemsBtn()

    }
    
    @IBAction func photosBlurryClick(_ sender: Any) {
        let vc = DDScreenshotsPhotosController()
        vc.screenshotsArr = self.photosBlurryArr
        vc.isBlur = true
        vc.handler = {
            self.updateAllCategoryData()

        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func photosBlurrySelBtnClick(_ sender: Any) {
        
        self.photosBlurrySelBtn.isSelected = !self.photosBlurrySelBtn.isSelected
        updateCleanItemsBtn()

    }
    
    @IBAction func videosDuplicateClick(_ sender: Any) {
        let vc = DDDuplicateVideosController()
        vc.originalDuplicateArr = self.videosDuplicateOriginalArr
        
        vc.handler = {
            self.updateAllCategoryData()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func videosDuplicateSelBtnClick(_ sender: Any) {
        
        self.videosDuplicateSelBtn.isSelected = !self.videosDuplicateSelBtn.isSelected
        updateCleanItemsBtn()

    }
    
    @IBAction func videosScreenClick(_ sender: Any) {
        
        let vc = DDScreenRecordingsController()
        vc.screenArr = self.videosScreenArr
        vc.handler = {
            self.updateAllCategoryData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func videoScreenSelBtnClick(_ sender: Any) {
        self.videosScreenSelBtn.isSelected = !self.videosScreenSelBtn.isSelected
        updateCleanItemsBtn()

    }
    
    @IBAction func videosShortClick(_ sender: Any) {
        
        let vc = DDScreenRecordingsController()
        vc.screenArr = self.videosShortArr
        vc.isShortRecording = true
        vc.handler = {
            self.updateAllCategoryData()

        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func videoShortSelBtnClick(_ sender: Any) {
        
        self.videosShortSelBtn.isSelected = !self.videosShortSelBtn.isSelected
        updateCleanItemsBtn()

    }
    
    
    @IBAction func contactsDuplicateClick(_ sender: Any) {
        let vc = DDDuplicateContactsController()
        vc.duplicateArr = self.contactsDuplicateArr
        vc.handler = {
            self.updateAllCategoryData()
        }
        self.navigationController?.pushViewController(vc, animated: true)


    }
    
    @IBAction func contactsDuplicateSelBtnClick(_ sender: Any) {
        self.contactsDuplicateSelBtn.isSelected = !self.contactsDuplicateSelBtn.isSelected
        updateCleanItemsBtn()

    }
     
    @IBAction func contactsIncompleteClick(_ sender: Any) {
        
        let vc = DDContactsListController()
        vc.isIncomplete = true
        vc.handler = {
            self.updateAllCategoryData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func contactsIncompleteSelBtnClick(_ sender: Any) {
        
        self.contactsIncompleteSelBtn.isSelected = !self.contactsIncompleteSelBtn.isSelected
        updateCleanItemsBtn()

    }
    
    @IBAction func eventsPastClick(_ sender: Any) {
        
        let vc = DDCalendarController()
        vc.handler = {
            self.updateAllCategoryData()
        }
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func eventsPastSelBtnClick(_ sender: Any) {
        self.eventsPastSelBtn.isSelected = !self.eventsPastSelBtn.isSelected
        updateCleanItemsBtn()

    }

    
    
    @IBAction func cleanItemsClick(_ sender: Any) {
        
        let vc = DDCleaningController()
        
        
        vc.photosSimilarOriginalArr = self.photosSimilarSelBtn.isSelected ? self.photosSimilarOriginalArr : []
        vc.photosDuplicateOriginalArr = self.photosDuplicateSelBtn.isSelected ? self.photosDuplicateOriginalArr : []
        vc.photosScreenshotsArr = self.photosShotsSelBtn.isSelected ? self.photosScreenshotsArr : []
        vc.photosBlurryArr = self.photosBlurrySelBtn.isSelected ? self.photosBlurryArr : []
        vc.videosDuplicateOriginalArr = self.videosDuplicateSelBtn.isSelected ? self.videosDuplicateOriginalArr : []
        vc.videosScreenArr = self.videosScreenSelBtn.isSelected ? self.videosScreenArr : []
        vc.videosShortArr = self.videosShortSelBtn.isSelected ? self.videosShortArr : []
        vc.contactsDuplicateArr = self.contactsDuplicateSelBtn.isSelected ? self.contactsDuplicateArr : []
        vc.contactsIncompleteArr = self.contactsIncompleteSelBtn.isSelected ? self.contactsIncompleteArr : []
        vc.eventsPastArr = self.eventsPastSelBtn.isSelected ? self.eventsPastArr : []
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
