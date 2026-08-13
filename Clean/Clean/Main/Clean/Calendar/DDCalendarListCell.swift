import UIKit

class DDCalendarListCell: UITableViewCell {

    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var selBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
