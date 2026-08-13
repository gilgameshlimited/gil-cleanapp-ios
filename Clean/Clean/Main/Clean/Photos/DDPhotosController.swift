import UIKit
import Photos

class DDPhotosController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var originalSimilarArr: [[PHAsset]] = []
    var similarArr: [PHAsset] = []
    var originalDuplicateArr: [[PHAsset]] = []
    var duplicateArr: [PHAsset] = []
    var screenshotsArr: [PHAsset] = []
    var blurArr: [PHAsset] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var similarTitleLab: UILabel!
    @IBOutlet weak var similarSpaceLab: UILabel!
    @IBOutlet weak var similarCountLab: UILabel!
    @IBOutlet weak var similarNoDataBGView: UIView!
    @IBOutlet weak var similarCollectionView: UICollectionView!
    
    @IBOutlet weak var duplicateTitleLab: UILabel!
    @IBOutlet weak var duplicateSpaceLab: UILabel!
    @IBOutlet weak var duplicateCountLab: UILabel!
    @IBOutlet weak var duplicateNoDataBGView: UIView!
    @IBOutlet weak var duplicateCollectionView: UICollectionView!
    
    
    @IBOutlet weak var screenshotsTitleLab: UILabel!
    @IBOutlet weak var screenshotsSpaceLab: UILabel!
    @IBOutlet weak var screenshotsCountLab: UILabel!
    @IBOutlet weak var screenshotsNoDataBGView: UIView!
    @IBOutlet weak var screenshotsCollectionView: UICollectionView!
    
    
    @IBOutlet weak var blurTitleLab: UILabel!
    @IBOutlet weak var blurSpaceLab: UILabel!
    @IBOutlet weak var blurCountLab: UILabel!
    @IBOutlet weak var blurNoDataBGView: UIView!
    @IBOutlet weak var blurCollectionView: UICollectionView!


    @IBOutlet weak var titlelab: UILabel!
    @IBOutlet weak var sinimlarNodataLab: UILabel!
    
    @IBOutlet weak var blurryNodataLab: UILabel!
    @IBOutlet weak var screenshotsNodatalab: UILabel!
    @IBOutlet weak var duplicateNodataLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 508 + 148 + 20)
        self.tableView.tableHeaderView = self.tableHeaderView
        self.tableView.tableFooterView = UIView()
        
        
        self.similarCollectionView.delegate = self
        self.similarCollectionView.dataSource = self
        self.similarCollectionView.register(UINib(nibName: "DDSimilarImageCell", bundle: nil), forCellWithReuseIdentifier: "DDSimilarImageCell")
        self.similarCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        self.duplicateCollectionView.delegate = self
        self.duplicateCollectionView.dataSource = self
        self.duplicateCollectionView.register(UINib(nibName: "DDSimilarImageCell", bundle: nil), forCellWithReuseIdentifier: "DDSimilarImageCell")
        self.duplicateCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

        
        self.screenshotsCollectionView.delegate = self
        self.screenshotsCollectionView.dataSource = self
        self.screenshotsCollectionView.register(UINib(nibName: "DDSimilarImageCell", bundle: nil), forCellWithReuseIdentifier: "DDSimilarImageCell")
        self.screenshotsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        
        self.blurCollectionView.delegate = self
        self.blurCollectionView.dataSource = self
        self.blurCollectionView.register(UINib(nibName: "DDSimilarImageCell", bundle: nil), forCellWithReuseIdentifier: "DDSimilarImageCell")
        self.blurCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

        setupLocalization()
        updateAllCategoryPhotos()

    }
    
    func setupLocalization() {
        self.titlelab.text = DDlocal("DDPhotos")
        self.similarTitleLab.text = DDlocal("DDSimilar")
        self.duplicateTitleLab.text = DDlocal("DDDuplicate")
        self.screenshotsTitleLab.text = DDlocal("DDScreenshots")
        self.blurTitleLab.text = DDlocal("DDBlurry")
        
        self.sinimlarNodataLab.text = DDlocal("DDNothing_to_clean_here")
        self.duplicateNodataLab.text = DDlocal("DDNothing_to_clean_here")
        self.screenshotsNodatalab.text = DDlocal("DDNothing_to_clean_here")
        self.blurryNodataLab.text = DDlocal("DDNothing_to_clean_here")
        
        self.titlelab.adjustsFontSizeToFitWidth = true
        self.similarTitleLab.adjustsFontSizeToFitWidth = true
        self.duplicateTitleLab.adjustsFontSizeToFitWidth = true
        self.screenshotsTitleLab.adjustsFontSizeToFitWidth = true
        self.blurTitleLab.adjustsFontSizeToFitWidth = true
        
        self.sinimlarNodataLab.adjustsFontSizeToFitWidth = true
        self.duplicateNodataLab.adjustsFontSizeToFitWidth = true
        self.screenshotsNodatalab.adjustsFontSizeToFitWidth = true
        self.blurryNodataLab.adjustsFontSizeToFitWidth = true


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func updateAllCategoryPhotos() {
        self.fetchSimilarPhotos()
        self.fetchDuplicatePhotos()
        self.fetchScreenshotsPhotos()
        self.fetchBlurPhotos()
    }
    
    func fetchBlurPhotos() {
        
        self.blurArr = []
        self.blurCollectionView.reloadData()
        
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
                    
                    DDPhotosManager.shared.fetchBlurredPhotos { assets in
                        
                        self.blurArr = assets
                        
                        DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: self.blurArr) { sizeStr in
                            
                            DispatchQueue.main.async {
                                
                                self.blurSpaceLab.text = sizeStr

                            }

                        }
                        
                        DispatchQueue.main.async {
                            self.blurCountLab.text = "\(self.blurArr.count)"
                            self.blurCollectionView.reloadData()
                        }

                        
                    }

                }
                
               
                
            }
        }
        

    }
    

    
    func fetchScreenshotsPhotos() {
        
        self.screenshotsArr = []
        self.screenshotsCollectionView.reloadData()
        
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
                    
                    self.screenshotsArr = DDPhotosManager.shared.fetchScreenshotPhotos()
                    
                    DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: self.screenshotsArr) { sizeStr in
                        
                        DispatchQueue.main.async {
                            
                            self.screenshotsSpaceLab.text = sizeStr

                        }

                    }
                    
                    DispatchQueue.main.async {
                        self.screenshotsCountLab.text = "\(self.screenshotsArr.count)"
                        self.screenshotsCollectionView.reloadData()
                    }

                }
                
               
                
            }
        }
        

    }
    
    func fetchDuplicatePhotos() {
        
        self.originalDuplicateArr = []
        self.duplicateArr = []
        self.duplicateCollectionView.reloadData()
        
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
                    
                    DDPhotosManager.shared.findDuplicatePhotos { assets in
                        
                        self.originalDuplicateArr = assets
                        
                        for arr in self.originalDuplicateArr {
                            
                            for asset in arr {
                                self.duplicateArr.append(asset)
                            }

                        }
                        
                        DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: self.duplicateArr) { sizeStr in
                            
                            DispatchQueue.main.async {
                                
                                self.duplicateSpaceLab.text = sizeStr

                            }

                        }
                        
                        
                        DispatchQueue.main.async {
                            self.duplicateCountLab.text = "\(self.duplicateArr.count)"
                            self.duplicateCollectionView.reloadData()
                        }
                        
                        
                    }
                }
                
            }
        }
        
        
    }
    
    func fetchSimilarPhotos() {
        
        self.originalSimilarArr = []
        self.similarArr = []
        self.similarCollectionView.reloadData()

        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
                    
                    if let tempArr = AMPhotoManager.fectchSimilarArray() as? [[PHAsset]] {
                        self.originalSimilarArr = tempArr
                        for arr in self.originalSimilarArr {
                            
                            for asset in arr {
                                self.similarArr.append(asset)
                            }

                        }
                        
                        DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: self.similarArr) { sizeStr in
                            
                            DispatchQueue.main.async {
                                
                                self.similarSpaceLab.text = sizeStr

                            }

                        }
                        
                        
                        DispatchQueue.main.async {
                            self.similarCountLab.text = "\(self.similarArr.count)"
                            self.similarCollectionView.reloadData()
                        }

                    }
              
                }
                
            }
        }

    }
    
    
    @IBAction func backClick(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func similarClick(_ sender: Any) {
        
        let vc = DDSimilarPhotosController()
        
        vc.originalSimilarArr = self.originalSimilarArr
        
        vc.handler = {
            self.updateAllCategoryPhotos()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func duplicateClick(_ sender: Any) {
        
        let vc = DDSimilarPhotosController()
        vc.isDuplicate = true
        vc.originalSimilarArr = self.originalDuplicateArr
        
        vc.handler = {
            self.updateAllCategoryPhotos()

        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func screenshotsClick(_ sender: Any) {
     
        let vc = DDScreenshotsPhotosController()
        vc.screenshotsArr = self.screenshotsArr
        vc.isBlur = false
        vc.handler = {
            self.updateAllCategoryPhotos()

        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func blurClick(_ sender: Any) {
        
        let vc = DDScreenshotsPhotosController()
        vc.screenshotsArr = self.blurArr
        vc.isBlur = true
        vc.handler = {
            self.updateAllCategoryPhotos()

        }
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.similarCollectionView {
            if self.similarArr.count > 0 {
                self.similarNoDataBGView.isHidden = true
                self.similarCollectionView.isHidden = false
            } else {
                self.similarNoDataBGView.isHidden = false
                self.similarCollectionView.isHidden = true
            }
            
            return self.similarArr.count
        } else if collectionView == self.duplicateCollectionView {
            
            if self.duplicateArr.count > 0 {
                self.duplicateNoDataBGView.isHidden = true
                self.duplicateCollectionView.isHidden = false
            } else {
                self.duplicateNoDataBGView.isHidden = false
                self.duplicateCollectionView.isHidden = true
            }
            
            return self.duplicateArr.count
        } else if collectionView == self.screenshotsCollectionView {
            
            if self.screenshotsArr.count > 0 {
                self.screenshotsNoDataBGView.isHidden = true
                self.screenshotsCollectionView.isHidden = false
            } else {
                self.screenshotsNoDataBGView.isHidden = false
                self.screenshotsCollectionView.isHidden = true
            }
            
            return self.screenshotsArr.count
            
            
        } else {
            
            if self.blurArr.count > 0 {
                self.blurNoDataBGView.isHidden = true
                self.blurCollectionView.isHidden = false
            } else {
                self.blurNoDataBGView.isHidden = false
                self.blurCollectionView.isHidden = true
            }
            
            return self.blurArr.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.similarCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDSimilarImageCell", for: indexPath) as! DDSimilarImageCell
            
            let asset = self.similarArr[indexPath.row]
            
            cell.identifier = asset.localIdentifier
            
            return cell
            
        } else if collectionView == self.duplicateCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDSimilarImageCell", for: indexPath) as! DDSimilarImageCell
            
            let asset = self.duplicateArr[indexPath.row]
            
            cell.identifier = asset.localIdentifier
            
            return cell
            
        } else if collectionView == self.screenshotsCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDSimilarImageCell", for: indexPath) as! DDSimilarImageCell
            
            let asset = self.screenshotsArr[indexPath.row]
            
            cell.identifier = asset.localIdentifier
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDSimilarImageCell", for: indexPath) as! DDSimilarImageCell
            
            let asset = self.blurArr[indexPath.row]
            
            cell.identifier = asset.localIdentifier
            
            return cell

            
        }
        
      
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
            
        return CGSizeMake(90, 90)

        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8.0

        
    }





}
