import UIKit
import Contacts
import ContactsUI

class DDDuplicateContactsController: UIViewController, UITableViewDelegate, UITableViewDataSource, DDDuplicateContactsGroupCellDelegate {
   
    
    @IBOutlet weak var nodataLab: UILabel!
    @IBOutlet var nodateView: UIView!
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var handler: (() -> Void)?

    var duplicateArr: [[CNContact]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fd_prefersNavigationBarHidden = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "DDDuplicateContactsGroupCell", bundle: nil), forCellReuseIdentifier: "DDDuplicateContactsGroupCell")
        self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.nodateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarAndStatusBarHeight - kBottomSafeHeight)
        self.tableView.tableHeaderView = self.nodateView
        self.tableView.tableFooterView = UIView()
        
        setupLocalization()
    }

    func setupLocalization() {
        self.titleLab.text = DDlocal("DDDuplicate")

    }

    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DispatchQueue.main.async {
            if self.duplicateArr.count > 0 {
                self.tableView.tableHeaderView = UIView()
            } else {
                self.tableView.tableHeaderView = self.nodateView
            }
        }
        
        return self.duplicateArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDDuplicateContactsGroupCell") as! DDDuplicateContactsGroupCell
        cell.contactsArr = self.duplicateArr[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let tupleArr = self.duplicateArr[indexPath.row]
        
        let subTableH = 74 * tupleArr.count
        return 38.0 + 26.0 + 51.0 + 16.0 + CGFloat(subTableH) + 8.0 + 8.0
    }
    
    // MARK: - DDDuplicateContactsGroupCellDelegate
    
    func DDDuplicateContactsGroupCellDidClickMerge(contactsArr: [CNContact], indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "\(DDlocal("DDMerge")) \(contactsArr.count) \(DDlocal("DDContacts"))", message: DDlocal("DDOnce_merged_it_canno_be_reversed"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DDlocal("DDMerge"), style: .default, handler: { action in
            
            self.mergeContacts(contactsArr: contactsArr)
            
        }))
        alert.addAction(UIAlertAction(title: DDlocal("DDCancel"), style: .cancel))
        self.present(alert, animated: true)
        
    }
    
    func DDDuplicateContactsGroupCellDidClickPreview(contactsArr: [CNContact], indexPath: IndexPath) {
        
        let tempContact: CNMutableContact = DDSharedContactsManager.mergeContacts(contactsArr)
        let contactViewController = CNContactViewController(for: tempContact)
        
        // 设置是否允许编辑或动作按钮
        contactViewController.allowsEditing = false
        contactViewController.allowsActions = true
        
        self.navigationController?.pushViewController(contactViewController, animated: true)
        
    }
    
    
    func mergeContacts(contactsArr: [CNContact]) {
        
        DDSharedContactsManager.deleteContacts(contacts: contactsArr)
        
        let tempContact: CNMutableContact = DDSharedContactsManager.mergeContacts(contactsArr)
        // 创建联系人保存请求
        let saveRequest = CNSaveRequest()
        saveRequest.add(tempContact, toContainerWithIdentifier: nil)
        // 创建 CNContactStore 实例
        let store = CNContactStore()

        do {
            // 执行保存操作
            try store.execute(saveRequest)
            
            
            DispatchQueue.main.async {
                
                DDshowToast(DDlocal("DDSuccess"))
                
                
                if let hander = self.handler {
                    hander()
                }
                
                DispatchQueue.global().async {
                    self.duplicateArr = DDSharedContactsManager.findDuplicateNameContacts(contacts: DDContactsManager.shared.fetchAllContacts())

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            }

        } catch {
            
            DDshowToast(DDlocal("DDFail"))

        }
    }
    
    

}
