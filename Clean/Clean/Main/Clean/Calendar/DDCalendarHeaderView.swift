import UIKit

class DDCalendarHeaderView: UITableViewHeaderFooterView {

    
    @IBOutlet weak var titleLab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor(hexString: "#F0F0F0")
    }
    
}
