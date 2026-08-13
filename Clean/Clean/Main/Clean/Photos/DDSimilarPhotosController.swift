import UIKit

class DDSimilarPhotosController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var selBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cleanBtn: UIButton!
    
    var isDuplicate: Bool = false
    
    var handler: (() -> Void)?
    
    var delArr: [PHAsset] = []
    
    @IBOutlet weak var nodataLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var nodataBGView: UIView!
    
    var originalSimilarArr: [[PHAsset]] = [] {
        didSet {
            for arr in originalSimilarArr {
                
                for asset in arr {
                    
                    if asset != arr.first {
                        
                        self.delArr.append(asset)

                    }
                    
                }
            }
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        self.setupSubviews()
        
        setupLocalization()
        updateCleanViews()

        
    }
    
    func setupLocalization() {
        if self.isDuplicate {
            self.titleLab.text = DDlocal("DDDuplicate")
        } else {
            self.titleLab.text = DDlocal("DDSimilar")

        }
        self.nodataLab.text = DDlocal("DDNothing_to_clean_here")
        self.titleLab.adjustsFontSizeToFitWidth = true
        self.nodataLab.adjustsFontSizeToFitWidth = true

    }
    
    func setupSubviews() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "DDSimilarGroupCell", bundle: nil), forCellReuseIdentifier: "DDSimilarGroupCell")
        self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
       
        
        // 注册 KVO 监听 tableView 的 contentSize
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

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
        if keyPath == "contentSize", let tableView = object as? UITableView {
            let newHeight = tableView.contentSize.height
            
            if newHeight > SCREEN_HEIGHT - kNavBarHeight - kBottomSafeHeight - 51 - 11 {
                
                self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 51 + 11, right: 0)
                
                
            } else {
                
                self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
                
            }
            
        }
    }

    @IBAction func backClick(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selBtnClick(_ sender: Any) {
        
        if self.selBtn.isSelected {
            
            var tempArr: [PHAsset] = []
            for arr in originalSimilarArr {
                
                for asset in arr {
                    
                    tempArr.append(asset)
                    
                }
                
            }
            
            self.delArr = tempArr
            self.tableView.reloadData()
            self.updateCleanViews()
            self.selBtn.isSelected = false
            
        } else {
            
            self.delArr.removeAll()
            self.tableView.reloadData()
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
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.originalSimilarArr.count > 0 {
            self.tableView.isHidden = false
            self.cleanBtn.isHidden = false
            self.selBtn.isHidden = false
            self.nodataBGView.isHidden = true
        } else {
            self.tableView.isHidden = true
            self.cleanBtn.isHidden = true
            self.selBtn.isHidden = true
            self.nodataBGView.isHidden = false
        }
        
        return self.originalSimilarArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDSimilarGroupCell") as! DDSimilarGroupCell
        cell.isDuplicate = self.isDuplicate
        cell.dataArr = self.originalSimilarArr[indexPath.row]
        cell.selectionStyle = .none
        cell.vc = self
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 164
    }
    
    deinit {
        // 记得在销毁时移除观察者
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    

}
