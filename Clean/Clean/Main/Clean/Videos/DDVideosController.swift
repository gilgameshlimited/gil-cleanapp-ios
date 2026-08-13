import UIKit

class DDVideosController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var originalDuplicateArr: [[PHAsset]] = []
    
    var duplicateArr: [PHAsset] = []
    
    var screenArr: [PHAsset] = []

    var shortArr: [PHAsset] = []

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var duplicateTitleLab: UILabel!
    @IBOutlet weak var duplicateSpaceLab: UILabel!
    @IBOutlet weak var duplicateCountLab: UILabel!
    @IBOutlet weak var duplicateNoDataBGView: UIView!
    @IBOutlet weak var duplicateCollectionView: UICollectionView!
    
    @IBOutlet weak var screenTitleLab: UILabel!
    @IBOutlet weak var screenSpaceLab: UILabel!
    @IBOutlet weak var screenCountLab: UILabel!
    @IBOutlet weak var screenNoDataBGView: UIView!
    @IBOutlet weak var screenCollectionView: UICollectionView!
    
    @IBOutlet weak var shortTitleLab: UILabel!
    @IBOutlet weak var shortSpaceLab: UILabel!
    @IBOutlet weak var shortCountLab: UILabel!
    @IBOutlet weak var shortNoDataBGView: UIView!
    @IBOutlet weak var shortCollectionView: UICollectionView!

    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var shortsNodataLab: UILabel!
    @IBOutlet weak var duplicateNodataLab: UILabel!
    @IBOutlet weak var screenNodataLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 344 + 148 + 20)
        self.tableView.tableHeaderView = self.tableHeaderView
        self.tableView.tableFooterView = UIView()
        
        
        self.duplicateCollectionView.delegate = self
        self.duplicateCollectionView.dataSource = self
        self.duplicateCollectionView.register(UINib(nibName: "DDVideosCell", bundle: nil), forCellWithReuseIdentifier: "DDVideosCell")
        self.duplicateCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        
        self.screenCollectionView.delegate = self
        self.screenCollectionView.dataSource = self
        self.screenCollectionView.register(UINib(nibName: "DDVideosCell", bundle: nil), forCellWithReuseIdentifier: "DDVideosCell")
        self.screenCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        
        self.shortCollectionView.delegate = self
        self.shortCollectionView.dataSource = self
        self.shortCollectionView.register(UINib(nibName: "DDVideosCell", bundle: nil), forCellWithReuseIdentifier: "DDVideosCell")
        self.shortCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

        setupLocalization()

        updateAllCategoryVideos()


        
    }
    
    func setupLocalization() {
        self.titleLab.text = DDlocal("DDVideos")
        self.duplicateTitleLab.text = DDlocal("DDDuplicate")
        self.screenTitleLab.text = DDlocal("DDScreen_Recordings")
        self.shortTitleLab.text = DDlocal("DDShort_Recordings")
        
        self.duplicateNodataLab.text = DDlocal("DDNothing_to_clean_here")
        self.screenNodataLab.text = DDlocal("DDNothing_to_clean_here")
        self.shortsNodataLab.text = DDlocal("DDNothing_to_clean_here")
        
        
        self.titleLab.adjustsFontSizeToFitWidth = true
        self.duplicateTitleLab.adjustsFontSizeToFitWidth = true
        self.screenTitleLab.adjustsFontSizeToFitWidth = true
        self.shortTitleLab.adjustsFontSizeToFitWidth = true
        self.duplicateNodataLab.adjustsFontSizeToFitWidth = true
        self.screenNodataLab.adjustsFontSizeToFitWidth = true
        self.shortsNodataLab.adjustsFontSizeToFitWidth = true



    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func updateAllCategoryVideos() {
        
        self.fetchDuplicateVideos()
        self.fetchScreenVideos()
        self.fetchShortVideos()

    }
    
    func fetchShortVideos() {
        
        self.shortArr = []
        self.shortCollectionView.reloadData()
        
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
         
                    DDPhotosManager.shared.fetchShortVideos { assets in
                        
                        self.shortArr = assets
                        
                        DDPhotosManager.shared.getVideoPHAssetsTotalFileSize(assets: self.shortArr) { sizeStr in

                            DispatchQueue.main.async {
                                
                                self.shortSpaceLab.text = sizeStr

                            }

                        }
                        
                        
                        DispatchQueue.main.async {
                            self.shortCountLab.text = "\(self.shortArr.count)"
                            self.shortCollectionView.reloadData()
                        }
                        
                        
                    }
                }
                
            }
        }
        
        
    }


    
    
    func fetchDuplicateVideos() {
        
        self.originalDuplicateArr = []
        self.duplicateArr = []
        self.duplicateCollectionView.reloadData()
        
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
                    
                    DDPhotosManager.shared.findDuplicateVideos { assets in
                        
                        self.originalDuplicateArr = assets
                        
                        for arr in self.originalDuplicateArr {
                            
                            for asset in arr {
                                self.duplicateArr.append(asset)
                            }

                        }
                        
                        
                        DDPhotosManager.shared.getVideoPHAssetsTotalFileSize(assets: self.duplicateArr) { sizeStr in

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

    func fetchScreenVideos() {
        
        self.screenArr = []
        self.screenCollectionView.reloadData()
        
        DDPhotosManager.shared.requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                
                DispatchQueue.global().async {
          
                    DDPhotosManager.shared.fetchScreenRecordingVideos { assets in
                        
                        self.screenArr = assets
                        
                        
                        DDPhotosManager.shared.getVideoPHAssetsTotalFileSize(assets: self.screenArr) { sizeStr in

                            DispatchQueue.main.async {
                                
                                self.screenSpaceLab.text = sizeStr

                            }

                        }
                        
                        
                        DispatchQueue.main.async {
                            self.screenCountLab.text = "\(self.screenArr.count)"
                            self.screenCollectionView.reloadData()
                        }
                        
                        
                    }
                }
                
            }
        }
        
        
    }



    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func duplicateClick(_ sender: Any) {
        let vc = DDDuplicateVideosController()
        vc.originalDuplicateArr = self.originalDuplicateArr
        
        vc.handler = {
            self.updateAllCategoryVideos()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func screenRecordingsClick(_ sender: Any) {
        
        
        let vc = DDScreenRecordingsController()
        vc.screenArr = self.screenArr
        vc.handler = {
            self.updateAllCategoryVideos()

        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func shortRecordingClick(_ sender: Any) {
        let vc = DDScreenRecordingsController()
        vc.screenArr = self.shortArr
        vc.isShortRecording = true
        vc.handler = {
            self.updateAllCategoryVideos()

        }
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.duplicateCollectionView {
            
            if self.duplicateArr.count > 0 {
                self.duplicateNoDataBGView.isHidden = true
                self.duplicateCollectionView.isHidden = false
            } else {
                self.duplicateNoDataBGView.isHidden = false
                self.duplicateCollectionView.isHidden = true
            }
            
            return self.duplicateArr.count
        } else if collectionView == self.screenCollectionView {
            if self.screenArr.count > 0 {
                self.screenNoDataBGView.isHidden = true
                self.screenCollectionView.isHidden = false
            } else {
                self.screenNoDataBGView.isHidden = false
                self.screenCollectionView.isHidden = true
            }

            return self.screenArr.count
        } else {

            if self.shortArr.count > 0 {
                self.shortNoDataBGView.isHidden = true
                self.shortCollectionView.isHidden = false
            } else {
                self.shortNoDataBGView.isHidden = false
                self.shortCollectionView.isHidden = true
            }

            return self.shortArr.count

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.duplicateCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDVideosCell", for: indexPath) as! DDVideosCell
            
            let asset = self.duplicateArr[indexPath.row]
            
            cell.identifier = asset.localIdentifier
            
            return cell
            
        } else if collectionView == self.screenCollectionView {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDVideosCell", for: indexPath) as! DDVideosCell
            
            let asset = self.screenArr[indexPath.row]
            
            cell.identifier = asset.localIdentifier
            
            return cell

        } else {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDVideosCell", for: indexPath) as! DDVideosCell
            
            let asset = self.shortArr[indexPath.row]
            
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
