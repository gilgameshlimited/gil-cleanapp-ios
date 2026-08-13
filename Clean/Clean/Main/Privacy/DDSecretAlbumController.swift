import UIKit

class DDSecretAlbumController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nodataView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var navRightBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var nodataTitleLab: UILabel!
    
    @IBOutlet weak var nodataSubTitleLab: UILabel!
    var secretArr: [DDSecretAlbumModel] = []
    var selArr: [DDSecretAlbumModel] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "DDSecretAlbumCell", bundle: nil), forCellWithReuseIdentifier: "DDSecretAlbumCell")
        self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        self.secretArr = DDDataBaseManager.shared.getSecretAlbumList().reversed()
        self.collectionView.reloadData()

        
        self.navRightBtn.setTitle(DDlocal("DDEdit"), for: .normal)
        self.backBtn.setImage(UIImage(named: "clean_back"), for: .normal)
        
        setupLocalization()
    }
    
    func setupLocalization() {
        
        self.titleLab.text = DDlocal("DDSecret_Album")
        self.nodataTitleLab.text = DDlocal("No_Secret_Files")
        self.nodataSubTitleLab.text = DDlocal("DDTap_Add_button_to_add_secret")
        
        self.titleLab.adjustsFontSizeToFitWidth = true
        self.nodataTitleLab.adjustsFontSizeToFitWidth = true
        self.nodataSubTitleLab.adjustsFontSizeToFitWidth = true


    }

    @IBAction func backClick(_ sender: Any) {
        
        if self.backBtn.currentTitle == DDlocal("DDCancel") {
            
            self.selArr = []
            self.navRightBtn.setTitle(DDlocal("DDEdit"), for: .normal)
            self.addBtn.setTitle(DDlocal("DDAdd"), for: .normal)
            self.addBtn.backgroundColor = UIColor(hexString: "#3863FF")
            self.backBtn.setImage(UIImage(named: "clean_back"), for: .normal)
            self.backBtn.setTitle("", for: .normal)
            self.collectionView.reloadData()

        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func updateAddDelBtnBackgroudColor() {
        if self.addBtn.currentTitle == DDlocal("DDDelete") {
            
            if self.selArr.count > 0 {
                self.addBtn.backgroundColor = UIColor(hexString: "#3863FF")
            } else {
                self.addBtn.backgroundColor = UIColor(hexString: "#3863FF", alpha: 0.5)
            }
        }
       
    }
    
    @IBAction func navRightClick(_ sender: Any) {
        if self.navRightBtn.currentTitle == DDlocal("DDEdit") {
            self.selArr = []
            self.navRightBtn.setTitle(DDlocal("DDSelect_All"), for: .normal)
            self.backBtn.setTitle(DDlocal("DDCancel"), for: .normal)
            self.backBtn.setImage(UIImage(), for: .normal)
            self.addBtn.setTitle(DDlocal("DDDelete"), for: .normal)
            self.collectionView.reloadData()
            
            self.updateAddDelBtnBackgroudColor()
        } else if self.navRightBtn.currentTitle == DDlocal("DDSelect_All") {
            self.selArr = self.secretArr
            self.navRightBtn.setTitle(DDlocal("DDDeselect_All"), for: .normal)
            self.backBtn.setTitle(DDlocal("DDCancel"), for: .normal)
            self.collectionView.reloadData()
            self.updateAddDelBtnBackgroudColor()
        } else {
            self.selArr = []
            self.navRightBtn.setTitle(DDlocal("DDSelect_All"), for: .normal)
            self.backBtn.setTitle(DDlocal("DDCancel"), for: .normal)
            self.collectionView.reloadData()
            self.updateAddDelBtnBackgroudColor()
        }
    }
    
    @IBAction func addClick(_ sender: Any) {
        
        if self.addBtn.currentTitle == DDlocal("DDAdd") {
            
            if DDSharePreferences.checkSecretAlbumFirstRun() {
                let alert = UIAlertController(title: DDlocal("DDRemove_After_Import"), message: DDlocal("DDSelect_Remove_to_delete_the_imported_files"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: DDlocal("DDRemove"), style: .default, handler: { action in
                    
                    DDSharePreferences.secretAlbumRemoveOriginalPhotos = true
                    self.addPhotos()

                }))
                alert.addAction(UIAlertAction(title: DDlocal("DDDo_not_remove"), style: .cancel, handler: { action in
                    
                    DDSharePreferences.secretAlbumRemoveOriginalPhotos = false
                    self.addPhotos()

                }))
                self.present(alert, animated: true)
            } else {
                self.addPhotos()
            }
            
            
        } else {
            if self.selArr.count > 0 {
                
                for model in self.selArr {
                    DDDataBaseManager.shared.deleteSecretAlbumList(model: model)
                }
                DDshowToast(DDlocal("DDSuccess"))
                self.selArr = []
                self.navRightBtn.setTitle(DDlocal("DDEdit"), for: .normal)
                self.addBtn.setTitle(DDlocal("DDAdd"), for: .normal)
                self.addBtn.backgroundColor = UIColor(hexString: "#3863FF")
                self.backBtn.setImage(UIImage(named: "clean_back"), for: .normal)
                self.backBtn.setTitle("", for: .normal)

                self.secretArr = DDDataBaseManager.shared.getSecretAlbumList().reversed()
                self.collectionView.reloadData()
                
            }
        }
        
    }
    
    func addPhotos() {
        
        
        let pickerVC = TZImagePickerController(maxImagesCount: 9, delegate: nil)
        pickerVC?.allowPickingVideo = false
        pickerVC?.allowPickingImage = true
        pickerVC?.allowPreview = false
        pickerVC?.isSelectOriginalPhoto = true
        pickerVC?.modalPresentationStyle = .fullScreen

        pickerVC?.didFinishPickingPhotosHandle = {[weak self] images, assets, isSelectOriginalPhoto in
            
            if let images = images {
                
                let PHassets: [PHAsset]? = assets as? [PHAsset]
                
                if DDSharePreferences.secretAlbumRemoveOriginalPhotos == true {
                    DDPhotosManager.shared.deletePhotos(assets: PHassets ?? [], handler: nil)
                }
                
                for img in images {
                    
                    let model = DDSecretAlbumModel()
                    model.image = img
                    DDDataBaseManager.shared.saveSecretAlbum(model: model)
                    
                }
                DDshowToast(DDlocal("DDSuccess"))
                self?.secretArr = DDDataBaseManager.shared.getSecretAlbumList().reversed()
                self?.collectionView.reloadData()
                
            }
            
  
        }

        
        self.present(pickerVC!, animated: true)

    }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        DispatchQueue.main.async {
            
            if self.secretArr.count > 0 {
                
                self.nodataView.isHidden = true
                self.collectionView.isHidden = false
                self.navRightBtn.isHidden = false
                
            } else {
                
                self.nodataView.isHidden = false
                self.collectionView.isHidden = true
                self.navRightBtn.isHidden = true
            }
            
            
        }
        
        
        return self.secretArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDSecretAlbumCell", for: indexPath) as! DDSecretAlbumCell
        
        cell.imgView.image = self.secretArr[indexPath.row].image
        
        if self.navRightBtn.currentTitle == DDlocal("DDEdit") {
            cell.selBtn.isHidden = true
        } else {
            
            if self.selArr.contains(self.secretArr[indexPath.row]) {
                cell.selBtn.isSelected = true
            } else {
                cell.selBtn.isSelected = false
            }
            
            cell.selBtn.isHidden = false

        }
        
        
        
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.navRightBtn.currentTitle == DDlocal("DDEdit") {
            
            let vc = DDPhotoDetailController()
            vc.model = self.secretArr[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        
        } else {
            let model = self.secretArr[indexPath.row]

            if let index = self.selArr.firstIndex(of: model) {
                self.selArr.remove(at: index)
            } else {
                self.selArr.append(model)
            }
            self.collectionView.reloadData()
            self.updateAddDelBtnBackgroudColor()

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let W = (SCREEN_WIDTH - 16.0 - 16.0 - 6.0 - 6.0)/3.0
            
        return CGSizeMake(W, W)
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 6.0

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }

    

}
