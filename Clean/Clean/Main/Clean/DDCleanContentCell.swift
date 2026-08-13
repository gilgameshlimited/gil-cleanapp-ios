import UIKit

class DDCleanContentCell: UITableViewCell {

    @IBOutlet weak var selBtn: UIButton!
    
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var numLab: UILabel!
    
    @IBOutlet weak var subtitleLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
