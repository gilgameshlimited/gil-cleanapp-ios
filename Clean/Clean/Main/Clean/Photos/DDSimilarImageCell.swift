import UIKit

class DDSimilarImageCell: UICollectionViewCell {

    @IBOutlet weak var selBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    var identifier: String? {
        didSet {
            
            if let identifier = identifier {
                AMPhotoManager.asyncRequestImage(withIdentifier: identifier, size: CGSize(width: 300, height: 300)) { img in
                    self.imgView.image = img
                }
                
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
