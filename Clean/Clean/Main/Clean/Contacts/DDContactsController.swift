import UIKit
import Contacts

class DDContactsController: UIViewController {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    
    @IBOutlet weak var duplicateTitleLab: UILabel!
    @IBOutlet weak var duplicateSubTitleLab: UILabel!
    
    @IBOutlet weak var incompleteTitleLab: UILabel!
    @IBOutlet weak var incompleteSubTitleLab: UILabel!
    @IBOutlet weak var allContactsTitleLab: UILabel!
    
    @IBOutlet weak var duplicateNumLab: UILabel!
    
    @IBOutlet weak var incompleteNumLab: UILabel!
    
    @IBOutlet weak var allContactsNumLab: UILabel!
    
    var allContacts: [CNContact] = []
    var duplicateContacts: [[CNContact]] = []
    var incompleteContacts: [CNContact] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fd_prefersNavigationBarHidden = true
        
        //265 70 20
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 265.0 + 70.0 + 20.0)
        self.tableView.tableHeaderView = self.tableHeaderView
        self.tableView.tableFooterView = UIView()
        
        self.setupLocalization()
        self.loadData()

    }
    
    func setupLocalization() {
        self.titleLab.text = DDlocal("DDContacts")
        self.duplicateTitleLab.text = DDlocal("DDDuplicate")
        self.duplicateSubTitleLab.text = DDlocal("DDNames_Numbers_Emails")
        self.incompleteTitleLab.text = DDlocal("DDIncomplete")
        self.incompleteSubTitleLab.text = DDlocal("DDNo_Names_No_Numbers_No_Emails")
        self.allContactsTitleLab.text = DDlocal("DDAll_Contacts")
        
        self.titleLab.adjustsFontSizeToFitWidth = true
        self.duplicateTitleLab.adjustsFontSizeToFitWidth = true
        self.duplicateSubTitleLab.adjustsFontSizeToFitWidth = true
        self.incompleteTitleLab.adjustsFontSizeToFitWidth = true
        self.incompleteSubTitleLab.adjustsFontSizeToFitWidth = true
        self.allContactsTitleLab.adjustsFontSizeToFitWidth = true


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadData() {
        
        self.allContacts = []
        self.duplicateContacts = []
        self.duplicateNumLab.text = "0"
        self.allContactsNumLab.text = "0"
        self.incompleteNumLab.text = "0"

        
        DDSharedContactsManager.checkContactAuthorizationStatus { success in
            
            if success {
                
                DispatchQueue.global().async {
                    
                    self.allContacts = DDContactsManager.shared.fetchAllContacts()
                    self.duplicateContacts = DDSharedContactsManager.findDuplicateNameContacts(contacts: self.allContacts)
                    self.incompleteContacts = DDSharedContactsManager.filterIncompleteContacts(contacts: self.allContacts)
                                        
                    DispatchQueue.main.async {
                        self.duplicateNumLab.text = "\(self.duplicateContacts.count)"
                        self.allContactsNumLab.text = "\(self.allContacts.count)"
                        self.incompleteNumLab.text = "\(self.incompleteContacts.count)"

                    }
                    
                }
                
            } else {
             
                DDSharedContactsManager.showContactsPermissionsAlert()
                
            }
            
        }

    }

    @IBAction func duplicateClick(_ sender: Any) {
        
        let vc = DDDuplicateContactsController()
        vc.duplicateArr = self.duplicateContacts
        vc.handler = {
            self.loadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func incompleteClick(_ sender: Any) {
        let vc = DDContactsListController()
        vc.isIncomplete = true
        vc.handler = {
            self.loadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func allContactsClick(_ sender: Any) {
        
        let vc = DDContactsListController()
        vc.handler = {
            self.loadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func backClick(_ sender: Any) {
        
    }

}
