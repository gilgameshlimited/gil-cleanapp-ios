import UIKit

class DDDuplicateVideosGroupCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var subtitleLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var vc: DDDuplicateVideosController?
    
    var dataArr: [PHAsset] = [] {
        didSet {
            
            self.titleLab.text = "\(self.dataArr.count) \(DDlocal("DDDuplicate"))"
            self.collectionView.reloadData()
            
            DispatchQueue.global().async {
                                
                DDPhotosManager.shared.getVideoPHAssetsTotalFileSize(assets: self.dataArr) { sizeStr in
                    
                    DispatchQueue.main.async {
                        
                        self.subtitleLab.text = sizeStr

                    }
                }
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "DDVideosCell", bundle: nil), forCellWithReuseIdentifier: "DDVideosCell")
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

    }
    
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDVideosCell", for: indexPath) as! DDVideosCell
        
        let asset = self.dataArr[indexPath.row]
        cell.selBtn.isHidden = false
        cell.identifier = asset.localIdentifier
        
        if let vc = vc, vc.delArr.contains(asset) {
            cell.selBtn.isSelected = true
        } else {
            cell.selBtn.isSelected = false
        }
        
        
        return cell
        
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let asset = self.dataArr[indexPath.row]

        if let vc = vc, let index = vc.delArr.firstIndex(of: asset) {
            vc.delArr.remove(at: index)
        } else {
            vc?.delArr.append(asset)
        }
        
        vc?.updateCleanViews()
        self.collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
            
        return CGSizeMake(90, 90)

        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8.0

        
    }


    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
