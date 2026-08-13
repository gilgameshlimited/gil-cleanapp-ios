import UIKit
import Contacts

protocol DDSecretContactListCellDelegate: AnyObject {

    func DDSecretContactListCellDidClickSelect(selected: Bool, contact: CNContact)


}

class DDSecretContactListCell: UITableViewCell {

    @IBOutlet weak var selBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var selBtnWidth: NSLayoutConstraint!//20
    
    @IBOutlet weak var selBtnTrailing: NSLayoutConstraint!//16
    weak var delegate: DDSecretContactListCellDelegate?
    var contact: CNContact?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func selectClick(_ sender: Any) {
        
        self.selBtn.isSelected = !self.selBtn.isSelected
        
        delegate?.DDSecretContactListCellDidClickSelect(selected: self.selBtn.isSelected, contact: self.contact ?? CNContact())
        
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
