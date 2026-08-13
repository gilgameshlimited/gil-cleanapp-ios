import UIKit

protocol DDDuplicateContactsCellDelegate: AnyObject {
    func DDDuplicateContactsCellDidSelected(indexPath: IndexPath, selected: Bool)
}

class DDDuplicateContactsCell: UITableViewCell {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var selBtn: UIButton!
    var indexPath: IndexPath?
    weak var delegate: DDDuplicateContactsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func selectClick(_ sender: Any) {
        
        self.selBtn.isSelected = !self.selBtn.isSelected
        
        if let indexPath = self.indexPath {
            delegate?.DDDuplicateContactsCellDidSelected(indexPath: indexPath, selected: self.selBtn.isSelected)
        }
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
