import UIKit
import Contacts

protocol DDContactListCellDelegate: AnyObject {
    
    func DDContactListCellDidClickSelect(selected: Bool, contact: CNContact)
    
    
}

class DDContactListCell: UITableViewCell {

    @IBOutlet weak var selBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    
    weak var delegate: DDContactListCellDelegate?
    var contact: CNContact?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func selectClick(_ sender: Any) {
        
        self.selBtn.isSelected = !self.selBtn.isSelected
        
        delegate?.DDContactListCellDidClickSelect(selected: self.selBtn.isSelected, contact: self.contact ?? CNContact())
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
