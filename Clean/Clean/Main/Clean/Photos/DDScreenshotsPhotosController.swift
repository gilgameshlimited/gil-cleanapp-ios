import UIKit

class DDScreenshotsPhotosController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var nodataBGView: UIView!
    @IBOutlet weak var selBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var countLab: UILabel!
    @IBOutlet weak var cleanBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    
    var isBlur: Bool = false
    
    var handler: (() -> Void)?
    
    var delArr: [PHAsset] = []
    
    var screenshotsArr: [PHAsset] = [] {
        didSet {

            self.delArr = screenshotsArr

        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        self.setupSubviews()
        
        updateCleanViews()

        
        
    }
    
    func setupSubviews() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "DDSimilarImageCell", bundle: nil), forCellWithReuseIdentifier: "DDSimilarImageCell")
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16)

        
        // 注册 KVO 监听 tableView 的 contentSize
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.countLab.text = "\(self.screenshotsArr.count) \(DDlocal("DDPhotos"))"
        
        if self.isBlur {
            self.titleLab.text = DDlocal("DDBlurry")
        } else {
            self.titleLab.text = DDlocal("DDScreenshots")

        }

    }

    
    func updateCleanViews() {
        
        if self.delArr.count > 0 {
            self.cleanBtn.backgroundColor = DDThemeColor
            DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: self.delArr) { sizeStr in
                
                self.cleanBtn.setTitle("\(DDlocal("DDClean")) \(self.delArr.count) \(DDlocal("DDPhotos")) (\(sizeStr))", for: .normal)

            }
        } else {
            self.cleanBtn.backgroundColor = UIColor(hexString: "#3863FF", alpha: 0.5)
            
            self.cleanBtn.setTitle("\(DDlocal("DDClean")) 0 \(DDlocal("DDPhotos"))", for: .normal)

        }

    }
    
   
    // 实现观察者方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let collectionView = object as? UICollectionView {
            let newHeight = collectionView.contentSize.height
            
            if newHeight > SCREEN_HEIGHT - kNavBarHeight - kBottomSafeHeight - 51 - 11 {
                
                self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 51 + 11 + 12, right: 16)

                
            } else {
                
                self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16)

            }
            
        }
    }

    @IBAction func backClick(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selBtnClick(_ sender: Any) {
        
        if self.selBtn.isSelected {
            
            self.delArr = self.screenshotsArr
            self.collectionView.reloadData()
            self.updateCleanViews()
            self.selBtn.isSelected = false
            
        } else {
            
            self.delArr.removeAll()
            self.collectionView.reloadData()
            self.updateCleanViews()
            self.selBtn.isSelected = true
            
            
        }
        
    }
    
    @IBAction func cleanClick(_ sender: Any) {
        
        if self.delArr.count > 0 {
            
            SVProgressHUD.show()
            
            DDPhotosManager.shared.getImagePHAssetsTotalFileSize(assets: self.delArr) { sizeStr in
                DDPhotosManager.shared.deletePhotos(assets: self.delArr) { success in
                    
                    SVProgressHUD.dismiss()
                    
                    if success {
                        

                        let vc = DDCleanSuccessController()
                        vc.handler = self.handler
                        vc.delArr = self.delArr
                        vc.delSizeStr = sizeStr
                        self.navigationController?.pushViewController(vc, animated: true)


                    } else {
                        DDshowToast(DDlocal("DDFail"))
                    }
                    
                    
                }
            }

            
        }
        
        
    }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.screenshotsArr.count > 0 {
            self.collectionView.isHidden = false
            self.cleanBtn.isHidden = false
            self.selBtn.isHidden = false
            self.countLab.isHidden = false
            self.nodataBGView.isHidden = true
        } else {
            self.collectionView.isHidden = true
            self.cleanBtn.isHidden = true
            self.selBtn.isHidden = true
            self.countLab.isHidden = true
            self.nodataBGView.isHidden = false
        }
        
        return self.screenshotsArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDSimilarImageCell", for: indexPath) as! DDSimilarImageCell
        
        let asset = self.screenshotsArr[indexPath.row]
        cell.selBtn.isHidden = false
        cell.identifier = asset.localIdentifier
        
        if self.delArr.contains(asset) {
            cell.selBtn.isSelected = true
        } else {
            cell.selBtn.isSelected = false
        }
        
        
        return cell
        
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let asset = self.screenshotsArr[indexPath.row]

        if let index = self.delArr.firstIndex(of: asset) {
            self.delArr.remove(at: index)
        } else {
            self.delArr.append(asset)
        }
        
        self.collectionView.reloadData()
        self.updateCleanViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (SCREEN_WIDTH - 16.0 - 16.0 - 6.0 - 6.0) / 3.0
            
        return CGSizeMake(width, width)

        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 6.0

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0
    }


    deinit {
        // 记得在销毁时移除观察者
        collectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    

}
