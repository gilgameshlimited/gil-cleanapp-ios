import UIKit
import Contacts

class DDCleaningController: UIViewController {
    

    var photosSimilarOriginalArr: [[PHAsset]] = []
    var photosDuplicateOriginalArr: [[PHAsset]] = []

    var photosScreenshotsArr: [PHAsset] = []

    var photosBlurryArr: [PHAsset] = []
    
    var videosDuplicateOriginalArr: [[PHAsset]] = []

    var videosScreenArr: [PHAsset] = []
    
    var videosShortArr: [PHAsset] = []
    
    var contactsDuplicateArr: [[CNContact]] = []
    
    var contactsIncompleteArr: [CNContact] = []

    var eventsPastArr: [DDCalendarEvent] = []

    @IBOutlet weak var smallCircleImgView: UIImageView!
    
    var totalFileSize: Double = 0.0
    
    @IBOutlet weak var percentLab: UILabel!
    
    @IBOutlet weak var remindLab: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        self.fd_interactivePopDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.clean()
        }
    }
    
    
    func clean() {
        
        self.addCricleAnimation()
        
        let serialQueue = DispatchQueue(label: "cleanAllCategory")
        let dispatchGruop = DispatchGroup()
        
        var totalCleanCount: Int = 0
        
        if self.photosSimilarOriginalArr.count > 0 {
            totalCleanCount = totalCleanCount + 1
        }
        if self.photosDuplicateOriginalArr.count > 0 {
            totalCleanCount = totalCleanCount + 1
        }
        if self.photosScreenshotsArr.count > 0 {
            totalCleanCount = totalCleanCount + 1
        }
        if self.photosBlurryArr.count > 0 {
            totalCleanCount = totalCleanCount + 1
        }
        if self.videosDuplicateOriginalArr.count > 0 {
            totalCleanCount = totalCleanCount + 1
        }
        if self.videosScreenArr.count > 0 {
            totalCleanCount = totalCleanCount + 1
        }
        if self.videosShortArr.count > 0 {
            totalCleanCount = totalCleanCount + 1
        }
        if self.contactsDuplicateArr.count > 0 {
            totalCleanCount = totalCleanCount + 1
        }
        if self.contactsIncompleteArr.count > 0 {
            totalCleanCount = totalCleanCount + 1
        }
        if self.eventsPastArr.count > 0 {
            totalCleanCount = totalCleanCount + 1
        }
        
        let onePercent = 1.0/Double(totalCleanCount)
        
        var currentCleanIndex = 0.0
        
        if self.photosSimilarOriginalArr.count > 0 {
            dispatchGruop.enter()
            serialQueue.async {
                self.cleanPhotosSimilar { success in
                    dispatchGruop.leave()

                    
                    DispatchQueue.main.async {
                        currentCleanIndex = currentCleanIndex + 1.0
                        let currentPercent = onePercent * currentCleanIndex * 100.0
                        self.percentLab.text = String(format: "%.0f%%", currentPercent)
                        self.remindLab.text = DDlocal("DDAnalyzing_similar_photos")
                    }
                    
                    
                }
            }
        }
        
        if self.photosDuplicateOriginalArr.count > 0 {
            dispatchGruop.enter()

            serialQueue.async {
                self.cleanPhotosDuplicate { success in
                    dispatchGruop.leave()

                    DispatchQueue.main.async {
                        
                        currentCleanIndex = currentCleanIndex + 1.0
                        let currentPercent = onePercent * currentCleanIndex * 100.0
                        self.percentLab.text = String(format: "%.0f%%", currentPercent)
                        self.remindLab.text = DDlocal("DDAnalyzing_duplicate_photos")
                        
                    }

                }
            }
        }
        
        if self.photosScreenshotsArr.count > 0 {
            dispatchGruop.enter()

            serialQueue.async {

                self.cleanPhotosScreenshots { success in
                    dispatchGruop.leave()

                    DispatchQueue.main.async {
                        
                        currentCleanIndex = currentCleanIndex + 1.0
                        let currentPercent = onePercent * currentCleanIndex * 100.0
                        self.percentLab.text = String(format: "%.0f%%", currentPercent)
                        self.remindLab.text = DDlocal("DDAnalyzing_screenshot_photos")

                    }

                }
            }
        }
        
        if self.photosBlurryArr.count > 0 {
            dispatchGruop.enter()

            serialQueue.async {
                self.cleanPhotosBlurry { success in
                    dispatchGruop.leave()

                    DispatchQueue.main.async {
                        
                        currentCleanIndex = currentCleanIndex + 1.0
                        let currentPercent = onePercent * currentCleanIndex * 100.0
                        self.percentLab.text = String(format: "%.0f%%", currentPercent)
                        self.remindLab.text = DDlocal("DDAnalyzing_blurry_photos")

                    }

                }
            }
        }
        
        
        if self.videosDuplicateOriginalArr.count > 0 {
            dispatchGruop.enter()

            serialQueue.async {
                self.cleanVideosDuplicate { success in
                    dispatchGruop.leave()

                    DispatchQueue.main.async {
                        
                        currentCleanIndex = currentCleanIndex + 1.0
                        let currentPercent = onePercent * currentCleanIndex * 100.0
                        self.percentLab.text = String(format: "%.0f%%", currentPercent)
                        self.remindLab.text = DDlocal("DDAnalyzing_duplicate_videos")

                    }

                }
            }
        }
        
        if self.videosScreenArr.count > 0 {
            dispatchGruop.enter()

            serialQueue.async {
                self.cleanVideosScreenRecordings { success in
                    dispatchGruop.leave()

                    DispatchQueue.main.async {
                        
                        currentCleanIndex = currentCleanIndex + 1.0
                        let currentPercent = onePercent * currentCleanIndex * 100.0
                        self.percentLab.text = String(format: "%.0f%%", currentPercent)
                        self.remindLab.text = DDlocal("DDAnalyzing_screen_recording_videos")
                    }

                }
            }
        }
        
        if self.videosShortArr.count > 0 {
            dispatchGruop.enter()

            serialQueue.async {
                self.cleanVideosShortRecordings { success in
                    dispatchGruop.leave()

                    DispatchQueue.main.async {
                        
                        currentCleanIndex = currentCleanIndex + 1.0
                        let currentPercent = onePercent * currentCleanIndex * 100.0
                        self.percentLab.text = String(format: "%.0f%%", currentPercent)
                        self.remindLab.text = DDlocal("DDAnalyzing_short_recording_videos")

                    }

                }
            }
        }
        
        if self.contactsDuplicateArr.count > 0 {
            dispatchGruop.enter()

            serialQueue.async {
                self.cleanContactDuplicate { success in
                    dispatchGruop.leave()

                    DispatchQueue.main.async {
                        
                        currentCleanIndex = currentCleanIndex + 1.0
                        let currentPercent = onePercent * currentCleanIndex * 100.0
                        self.percentLab.text = String(format: "%.0f%%", currentPercent)
                        self.remindLab.text = DDlocal("DDAnalyzing_duplicate_contacts")

                    }

                }
            }
        }
        
        if self.contactsIncompleteArr.count > 0 {
            dispatchGruop.enter()

            serialQueue.async {
                self.cleanContactIncomplete { success in
                    dispatchGruop.leave()
                    
                    DispatchQueue.main.async {
                        
                        currentCleanIndex = currentCleanIndex + 1.0
                        let currentPercent = onePercent * currentCleanIndex * 100.0
                        self.percentLab.text = String(format: "%.0f%%", currentPercent)
                        self.remindLab.text = DDlocal("DDAnalyzing_incomplete_contacts")

                    }

                }
            }
        }
        
        if self.eventsPastArr.count > 0 {
            dispatchGruop.enter()

            serialQueue.async {
                self.cleanEventsPast { success in
                    dispatchGruop.leave()

                    DispatchQueue.main.async {
                        
                        currentCleanIndex = currentCleanIndex + 1.0
                        let currentPercent = onePercent * currentCleanIndex * 100.0
                        self.percentLab.text = String(format: "%.0f%%", currentPercent)
                        self.remindLab.text = DDlocal("DDAnalyzing_past_events")

                    }

                }
            }
        }
       
        // 当所有任务完成时，通知主线程
        dispatchGruop.notify(queue: DispatchQueue.main) {
            
            self.calculateCleanedData()
            
        }
        
    }
    
    func calculateCleanedData() {
        
        var photosCount: Int = 0
        
        var photosSimilarDelArr: [PHAsset] = []
        
        for arr in self.photosSimilarOriginalArr {
            
            for asset in arr {
                
                if asset != arr.first {
                    
                    photosSimilarDelArr.append(asset)

                }
            }
            
        }
        
        var photosDuplicateDelArr: [PHAsset] = []
        
        for arr in self.photosDuplicateOriginalArr {
            
            for asset in arr {
                
                if asset != arr.first {
                    
                    photosDuplicateDelArr.append(asset)

                }
            }
            
        }
        
        photosCount = photosSimilarDelArr.count + photosDuplicateDelArr.count + self.photosScreenshotsArr.count + self.photosBlurryArr.count
        
        var videosCount: Int = 0

        var videosDuplicateDelArr: [PHAsset] = []
        
        for arr in self.videosDuplicateOriginalArr {
            
            for asset in arr {
                
                if asset != arr.first {
                    
                    videosDuplicateDelArr.append(asset)

                }
            }
            
        }

        videosCount = videosDuplicateDelArr.count + self.videosScreenArr.count + self.videosShortArr.count
        
        
        var contactsCount: Int = 0

        var delContactsArr: [CNContact] = []
        for sectionArr in self.contactsDuplicateArr {
            delContactsArr.append(contentsOf: sectionArr)
        }
        
        contactsCount = delContactsArr.count + self.contactsIncompleteArr.count
        
        
        var eventsCount: Int = self.eventsPastArr.count


        self.smallCircleImgView.layer.removeAnimation(forKey: "rotateAnimation")

        let vc = DDAllCleanSuccessController()
        vc.photosCount = photosCount
        vc.videosCount = videosCount
        vc.contactsCount = contactsCount
        vc.eventsCount = eventsCount
        vc.totalFileSize = self.totalFileSize
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func cleanPhotosSimilar(handler: @escaping (_ success: Bool) -> Void) {
        
        var photosSimilarDelArr: [PHAsset] = []
        
        for arr in self.photosSimilarOriginalArr {
            
            for asset in arr {
                
                if asset != arr.first {
                    
                    photosSimilarDelArr.append(asset)

                }
            }
            
        }
        
        DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: photosSimilarDelArr, convertUnits: false) { sizeStr in
            DDPhotosManager.shared.deletePhotos(assets: photosSimilarDelArr) { success in
                
                SVProgressHUD.dismiss()
                
                if success {

                    self.totalFileSize = (Double(sizeStr) ?? 0.0) + self.totalFileSize
                    
                    handler(true)
                    
                } else {
                    
                    handler(false)
                    
                }
                
            }
            
        }
        
    }
    

    func cleanPhotosDuplicate(handler: @escaping (_ success: Bool) -> Void) {
        
        var photosDuplicateDelArr: [PHAsset] = []
        
        for arr in self.photosDuplicateOriginalArr {
            
            for asset in arr {
                
                if asset != arr.first {
                    
                    photosDuplicateDelArr.append(asset)

                }
            }
            
        }
        
        DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: photosDuplicateDelArr, convertUnits: false) { sizeStr in
            DDPhotosManager.shared.deletePhotos(assets: photosDuplicateDelArr) { success in
                
                SVProgressHUD.dismiss()
                
                if success {

                    self.totalFileSize = (Double(sizeStr) ?? 0.0) + self.totalFileSize
                    
                    handler(true)
                    
                } else {
                    
                    handler(false)
                    
                }
                
            }
            
        }
        
    }
    
    func cleanPhotosScreenshots(handler: @escaping (_ success: Bool) -> Void) {
        
        DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: self.photosScreenshotsArr, convertUnits: false) { sizeStr in
            DDPhotosManager.shared.deletePhotos(assets: self.photosScreenshotsArr) { success in
                
                SVProgressHUD.dismiss()
                
                if success {

                    self.totalFileSize = (Double(sizeStr) ?? 0.0) + self.totalFileSize
                    
                    handler(true)
                    
                } else {
                    
                    handler(false)
                    
                }
                
            }
            
        }
        
    }
    
    func cleanPhotosBlurry(handler: @escaping (_ success: Bool) -> Void) {
        
        DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: self.photosBlurryArr, convertUnits: false) { sizeStr in
            DDPhotosManager.shared.deletePhotos(assets: self.photosBlurryArr) { success in
                
                SVProgressHUD.dismiss()
                
                if success {

                    self.totalFileSize = (Double(sizeStr) ?? 0.0) + self.totalFileSize
                    
                    handler(true)
                    
                } else {
                    
                    handler(false)
                    
                }
                
            }
            
        }
        
    }


    func cleanVideosDuplicate(handler: @escaping (_ success: Bool) -> Void) {
        
        var videosDuplicateDelArr: [PHAsset] = []
        
        for arr in self.videosDuplicateOriginalArr {
            
            for asset in arr {
                
                if asset != arr.first {
                    
                    videosDuplicateDelArr.append(asset)

                }
            }
            
        }
        DDPhotosManager.shared.getVideoPHAssetsTotalFileSize(assets: videosDuplicateDelArr, convertUnits: false) { sizeStr in
            DDPhotosManager.shared.deletePhotos(assets: videosDuplicateDelArr) { success in
                
                SVProgressHUD.dismiss()
                
                if success {

                    self.totalFileSize = (Double(sizeStr) ?? 0.0) + self.totalFileSize
                    
                    handler(true)
                    
                } else {
                    
                    handler(false)
                    
                }
                
            }
            
        }
        
    }
    
    
    func cleanVideosScreenRecordings(handler: @escaping (_ success: Bool) -> Void) {
         
        DDPhotosManager.shared.getVideoPHAssetsTotalFileSize(assets: self.videosScreenArr, convertUnits: false) { sizeStr in
            DDPhotosManager.shared.deletePhotos(assets: self.videosScreenArr) { success in
                
                SVProgressHUD.dismiss()
                
                if success {

                    self.totalFileSize = (Double(sizeStr) ?? 0.0) + self.totalFileSize
                    
                    handler(true)
                    
                } else {
                    
                    handler(false)
                    
                }
                
            }
            
        }
        
    }

    func cleanVideosShortRecordings(handler: @escaping (_ success: Bool) -> Void) {
         
        DDPhotosManager.shared.getVideoPHAssetsTotalFileSize(assets: self.videosShortArr, convertUnits: false) { sizeStr in
            DDPhotosManager.shared.deletePhotos(assets: self.videosShortArr) { success in
                
                SVProgressHUD.dismiss()
                
                if success {

                    self.totalFileSize = (Double(sizeStr) ?? 0.0) + self.totalFileSize
                    
                    handler(true)
                    
                } else {
                    
                    handler(false)
                    
                }
                
            }
            
        }
        
    }

    
    func cleanContactDuplicate(handler: @escaping (_ success: Bool) -> Void) {
        
        // 创建联系人保存请求
        let saveRequest = CNSaveRequest()

        var delContactsArr: [CNContact] = []
        for sectionArr in self.contactsDuplicateArr {
            delContactsArr.append(contentsOf: sectionArr)
            
            let tempContact: CNMutableContact = DDSharedContactsManager.mergeContacts(sectionArr)
            saveRequest.add(tempContact, toContainerWithIdentifier: nil)
        }
        DDSharedContactsManager.deleteContacts(contacts: delContactsArr)
        
        // 创建 CNContactStore 实例
        let store = CNContactStore()

        do {
            // 执行保存操作
            try store.execute(saveRequest)

            handler(true)

        } catch {
            
            handler(false)

        }
    }
    
    
    func cleanContactIncomplete(handler: @escaping (_ success: Bool) -> Void) {
        
        let success = DDSharedContactsManager.deleteContacts(contacts: self.contactsIncompleteArr)
        
        if success {
            handler(true)

        } else {
            handler(false)

        }
    
    }

    func cleanEventsPast(handler: @escaping (_ success: Bool) -> Void) {
        
        DDCalendarManager.shared.deleteCalendarEvents(events: self.eventsPastArr) { success in
            
            if success {
                handler(true)

            } else {
                
                handler(false)

            }
            
        }
    
    
    }



    
    
    func addCricleAnimation() {
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0.0  // 初始角度
        rotation.toValue = Double.pi * 2  // 旋转360度
        rotation.duration = 1.0  // 每次旋转持续时间
        rotation.repeatCount = Float.infinity  // 无限重复
        self.smallCircleImgView.layer.add(rotation, forKey: "rotateAnimation")

    }
    



}
