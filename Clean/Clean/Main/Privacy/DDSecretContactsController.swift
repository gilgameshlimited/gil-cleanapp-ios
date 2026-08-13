import UIKit
import Contacts
import ContactsUI

class DDSecretContactsController: UIViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate, CNContactViewControllerDelegate {
    
    
    @IBOutlet weak var nodataView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var navRightBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBGView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nodataTitleLab: UILabel!
    @IBOutlet weak var nodataSubtitleLab: UILabel!
    var dataDic: [String: [CNContact]] = [:]
    var keys: [String] = []
    var searchArr: [CNContact] = []
    var selArr: [CNContact] = []
    var currentSelContact: CNContact?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true

        self.configureSubviews()
        
        self.loadData()
        
        self.updateNavBtnBottomBtnFromEditBtnStyle()
     
        self.setupLocalization()
    }
    
    func setupLocalization() {
        self.titleLab.text = DDlocal("DDSecret_Contacts")
        self.nodataTitleLab.text = DDlocal("DDNo_Secret_Contacts")
        self.nodataSubtitleLab.text = DDlocal("DDTap_Add_button_to_add_contacts")

        self.titleLab.adjustsFontSizeToFitWidth = true
        self.nodataTitleLab.adjustsFontSizeToFitWidth = true
        self.nodataSubtitleLab.adjustsFontSizeToFitWidth = true

    }
    
    func configureSubviews() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // 注册 KVO 监听 tableView 的 contentSize
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tableView.register(UINib(nibName: "DDSecretContactListCell", bundle: nil), forCellReuseIdentifier: "DDSecretContactListCell")
        self.tableView.register(UINib(nibName: "DDContactHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "DDContactHeaderView")
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0.0
        }
        let attrStr = NSAttributedString(string: DDlocal("DDSearch"), attributes: [.foregroundColor: UIColor(hexString: "#A0A0A0")!, .font: UIFont.systemFont(ofSize: 14)])
        self.searchTextField.attributedPlaceholder = attrStr
        self.searchTextField.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
        
        self.navRightBtn.setTitle(DDlocal("DDEdit"), for: .normal)
    }
    
    
    func loadData() {
        self.dataDic = DDContactsManager.shared.groupContactsByFullName(contacts: DDContactsManager.shared.loadSecretContacts())
        let tempArr = Array(self.dataDic.keys)
        
        let sortedArray = tempArr.sorted { (a, b) -> Bool in
            // 处理 `#` 在最前的情况
            if a == "#" && b != "#" {
                return true
            } else if b == "#" && a != "#" {
                return false
            }
            // 处理 `1-9` 在中间的情况
            if a == "1-9" && b != "1-9" {
                return true
            } else if b == "1-9" && a != "1-9" {
                return false
            }
            // 处理字母排序的情况
            return a < b
        }
        
        self.keys = sortedArray
                            
        self.tableView.reloadData()
    }
    
    func updateNavBtnBottomBtnFromEditBtnStyle() {
        
        if self.navRightBtn.currentTitle == DDlocal("DDEdit") {

            self.backBtn.setTitle("", for: .normal)
            self.backBtn.setImage(UIImage(named: "clean_back"), for: .normal)
            self.addBtn.setTitle(DDlocal("DDAdd"), for: .normal)
            self.addBtn.backgroundColor = UIColor(hexString: "#3863FF")
            
        } else {
            
            self.backBtn.setTitle(DDlocal("DDCancel"), for: .normal)
            self.backBtn.setImage(UIImage(), for: .normal)
            self.addBtn.setTitle(DDlocal("DDDelete"), for: .normal)
            
            if self.selArr.count > 0 {
                self.addBtn.backgroundColor = UIColor(hexString: "#3863FF")
            } else {
                self.addBtn.backgroundColor = UIColor(hexString: "#3863FF", alpha: 0.5)
            }
            
        }
        
        
    }

    
    @objc func textDidChange(textField: UITextField) {
        
        searchArr.removeAll()

        if let searchText = textField.text, !searchText.isEmpty {
            
            let allValues = Array(self.dataDic.values)
            for tempArr in allValues {
                for contact in tempArr {
                    let firstNum = DDSharedContactsManager.getFirstAvailablePhoneNumber(for: contact) ?? ""
                    
                    if contact.fullName.contains(searchText) || (contact.fullName.isEmpty && firstNum.contains(searchText)) {
                        searchArr.append(contact)
                    }
                }
            }
        }
        
        tableView.reloadData()
        
        
        DispatchQueue.main.async {
            
            if self.searchArr.count > 0 {
                
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
                
            }
            
        }


    }

    @IBAction func backClick(_ sender: Any) {
        
        if self.backBtn.currentTitle == DDlocal("DDCancel") {
            
            self.selArr = []
            self.navRightBtn.setTitle(DDlocal("DDEdit"), for: .normal)
            self.updateNavBtnBottomBtnFromEditBtnStyle()
            self.tableView.reloadData()

        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
        
    @IBAction func navRightClick(_ sender: Any) {
        if self.navRightBtn.currentTitle == DDlocal("DDEdit") {
            self.selArr = []
            self.navRightBtn.setTitle(DDlocal("DDSelect_All"), for: .normal)
  
            self.updateNavBtnBottomBtnFromEditBtnStyle()
            self.tableView.reloadData()
            
        } else if self.navRightBtn.currentTitle == DDlocal("DDSelect_All") {
            
            var tempArr: [CNContact] = []
            for key in keys {
                if let arr = self.dataDic[key] {
                    for contact in arr {
                        tempArr.append(contact)
                    }
                }
            }
            self.selArr = tempArr
            self.navRightBtn.setTitle(DDlocal("DDDeselect_All"), for: .normal)
            self.updateNavBtnBottomBtnFromEditBtnStyle()
            self.tableView.reloadData()
        } else {
            self.selArr = []
            self.navRightBtn.setTitle(DDlocal("DDSelect_All"), for: .normal)
            self.updateNavBtnBottomBtnFromEditBtnStyle()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addClick(_ sender: Any) {
        
        if self.addBtn.currentTitle == DDlocal("DDAdd") {
            
            if DDSharePreferences.checkSecretContactsFirstRun() {
                let alert = UIAlertController(title: DDlocal("DDRemove_After_Import"), message: DDlocal("DDSelect_Remove_to_delete_imported_contacts_from_your_address"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: DDlocal("DDRemove"), style: .default, handler: { action in
                    
                    DDSharePreferences.secretContactsRemoveOriginalContacts = true
                    self.showContactPicker()

                }))
                alert.addAction(UIAlertAction(title: DDlocal("DDDo_not_remove"), style: .cancel, handler: { action in
                    
                    DDSharePreferences.secretContactsRemoveOriginalContacts = false
                    self.showContactPicker()

                }))
                self.present(alert, animated: true)
            } else {
                self.showContactPicker()
            }
            
            
        } else {
            if self.selArr.count > 0 {
                
                var tempArr = DDContactsManager.shared.loadSecretContacts()
                tempArr.removeAll(where: { self.selArr.contains($0) })
                DDContactsManager.shared.saveSecretContacts(contacts: tempArr)
                
                DDshowToast(DDlocal("DDSuccess"))
                self.dataDic = [:]
                self.keys = []
                self.selArr = []
                self.searchArr = []
                self.tableView.reloadData()
                self.navRightBtn.setTitle(DDlocal("DDEdit"), for: .normal)
                self.updateNavBtnBottomBtnFromEditBtnStyle()
                self.loadData()
                
            }
        }
        
    }
    
    
    // MARK: - CollectionView Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        DispatchQueue.main.async {
        
            if self.dataDic.count < 1 {
                self.nodataView.isHidden = false
                self.tableView.isHidden = true
                self.navRightBtn.isHidden = true
                self.searchBGView.isHidden = true
                self.view.backgroundColor = UIColor(hexString: "#EBF3FF")
                self.tableView.backgroundColor = UIColor(hexString: "#EBF3FF")
            } else {
                self.nodataView.isHidden = true
                self.tableView.isHidden = false
                self.navRightBtn.isHidden = false
                self.searchBGView.isHidden = false
                self.view.backgroundColor = .white
                self.tableView.backgroundColor = .white
            }
            
        }
        
        
        if self.searchArr.count > 0 {
            
            return 1
            
        } else {
                        
            return self.dataDic.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchArr.count > 0 {
            
            return self.searchArr.count
            
        } else {
            
            let arr = self.dataDic[self.keys[section]]
            return arr?.count ?? 0

        }

        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.searchArr.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DDSecretContactListCell") as! DDSecretContactListCell
            cell.selectionStyle = .none
            
            let contact = self.searchArr[indexPath.row]
            if contact.fullName.isEmpty {
                cell.titleLab.text = DDSharedContactsManager.getFirstAvailablePhoneNumber(for: contact) ?? ""
            } else {
                cell.titleLab.text = contact.fullName
            }
            cell.contact = contact

            
            if self.navRightBtn.currentTitle == DDlocal("DDEdit") {
                cell.selBtnWidth.constant = 0
                cell.selBtnTrailing.constant = 0
                cell.selBtn.isHidden = true
                
            } else {
                cell.selBtnWidth.constant = 20
                cell.selBtnTrailing.constant = 16
                cell.selBtn.isHidden = false
                
                if self.selArr.contains(contact) {
                    cell.selBtn.isSelected = true
                } else {
                    cell.selBtn.isSelected = false
                }
            }
            
            
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DDSecretContactListCell") as! DDSecretContactListCell
            cell.selectionStyle = .none
            let arr = self.dataDic[self.keys[indexPath.section]]
            if let contact = arr?[indexPath.row] {
                
                if contact.fullName.isEmpty {
                    cell.titleLab.text = DDSharedContactsManager.getFirstAvailablePhoneNumber(for: contact) ?? ""
                } else {
                    cell.titleLab.text = contact.fullName
                }
                
                cell.contact = contact
                
                if self.navRightBtn.currentTitle == DDlocal("DDEdit") {
                    cell.selBtnWidth.constant = 0
                    cell.selBtnTrailing.constant = 0
                    cell.selBtn.isHidden = true
                    
                } else {
                    cell.selBtnWidth.constant = 20
                    cell.selBtnTrailing.constant = 16
                    cell.selBtn.isHidden = false
                    
                    if self.selArr.contains(contact) {
                        cell.selBtn.isSelected = true
                    } else {
                        cell.selBtn.isSelected = false
                    }
                }
            
            }
          

            return cell
            
        }
     
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.navRightBtn.currentTitle == DDlocal("DDEdit") {
            
            if self.searchArr.count > 0 {
                
                self.currentSelContact = self.searchArr[indexPath.row]
                self.showContactDetail(contact: self.searchArr[indexPath.row])
                
            } else {
                let arr = self.dataDic[self.keys[indexPath.section]]
                if let contact = arr?[indexPath.row] {
                
                    self.currentSelContact = contact
                    self.showContactDetail(contact: contact)

                }

            }
            
        } else {
            
            if self.searchArr.count > 0 {
                
                let contact = self.searchArr[indexPath.row]

                if let index = self.selArr.firstIndex(of: contact) {
                    self.selArr.remove(at: index)
                } else {
                    self.selArr.append(contact)
                }
                
                self.tableView.reloadData()
                self.updateNavBtnBottomBtnFromEditBtnStyle()

                
            } else {
                
                let arr = self.dataDic[self.keys[indexPath.section]]
                if let contact = arr?[indexPath.row] {
                

                    if let index = self.selArr.firstIndex(of: contact) {
                        self.selArr.remove(at: index)
                    } else {
                        self.selArr.append(contact)
                    }
                    
                    self.tableView.reloadData()
                    self.updateNavBtnBottomBtnFromEditBtnStyle()
                    

                }

            }
            
          
        }
        
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.searchArr.count > 0 {
            
           return nil
            
        } else {
            
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DDContactHeaderView") as! DDContactHeaderView
            
            headerView.titleLab.text = self.keys[section]
            return headerView
        }

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.searchArr.count > 0 {
            return CGFloat.leastNormalMagnitude // 或者返回 0
            
        } else {
            return 41
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8 // 或者返回 0
    }

    
    
    // MARK: - contact picker
    func showContactDetail(contact: CNContact) {
        
        let mutableContact = DDContactsManager.shared.conversionMutableContact(contact)
        let contactViewController = CNContactViewController(for: mutableContact)
        contactViewController.delegate = self
        
        // 允许编辑联系人
        contactViewController.allowsEditing = true
        contactViewController.allowsActions = true // 允许执行联系动作（打电话、发送邮件等）
        self.navigationController?.pushViewController(contactViewController, animated: true)
        
    }
    
    // CNContactViewControllerDelegate 的委托方法，可以处理返回事件
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        var tempArr = DDContactsManager.shared.loadSecretContacts()

        // 处理用户编辑完成后的联系人
        if let updatedContact = contact, let currentSelContact = self.currentSelContact {
            
            if let index = tempArr.firstIndex(of: currentSelContact) {
                tempArr[index] = updatedContact
                DDContactsManager.shared.saveSecretContacts(contacts: tempArr)
                self.loadData()
            }
            
        }
        
    }
    
    // 显示联系人选择器
    func showContactPicker() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.predicateForEnablingContact = NSPredicate(value: true) // 允许所有联系人被选中
        contactPicker.modalPresentationStyle = .fullScreen
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    
    // 处理选择的多个联系人
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
       
        var tempArr = DDContactsManager.shared.loadSecretContacts()
        
        for contact in contacts {
            if !tempArr.contains(contact) {
                tempArr.append(contact)
            }
        }
        
        DDContactsManager.shared.saveSecretContacts(contacts: tempArr)
        
        self.loadData()
        
        if DDSharePreferences.secretContactsRemoveOriginalContacts == true {
            
            DDContactsManager.shared.checkContactAuthorizationStatus { success in
                DDContactsManager.shared.deleteContacts(contacts: contacts)
            }
            
        }
        
    }
    
    // 用户取消选择
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
    }
    

    // 实现观察者方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let tableView = object as? UITableView {
            let newHeight = tableView.contentSize.height
            
            if newHeight > SCREEN_HEIGHT - kNavBarHeight - kBottomSafeHeight - 62 - 51 - 11 {
                
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 51 + 11, right: 0)

            } else {
                
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                
            }
            
        }
    }
    
    deinit {
        // 记得在销毁时移除观察者
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }

    

}
