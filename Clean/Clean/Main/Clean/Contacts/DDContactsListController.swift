import UIKit
import Contacts
import ContactsUI

class DDContactsListController: UIViewController, UITableViewDelegate, UITableViewDataSource, DDContactListCellDelegate {

    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var nodataView: UIView!
    @IBOutlet weak var searchBGView: UIView!
    
    @IBOutlet weak var nodataLab: UILabel!
    var handler: (() -> Void)?

    var isIncomplete: Bool = false
    var dataDic: [String: [CNContact]] = [:]
    var keys: [String] = []
    var searchArr: [CNContact] = []
    var selArr: [CNContact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fd_prefersNavigationBarHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.nodataView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarAndStatusBarHeight - kBottomSafeHeight - 62)
        self.tableView.tableHeaderView = self.nodataView
        self.tableView.tableFooterView = UIView()
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0.0
        }
        // 注册 KVO 监听 tableView 的 contentSize
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        
        self.tableView.register(UINib(nibName: "DDContactListCell", bundle: nil), forCellReuseIdentifier: "DDContactListCell")
        self.tableView.register(UINib(nibName: "DDContactHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "DDContactHeaderView")

        let attrStr = NSAttributedString(string: DDlocal("DDSearch"), attributes: [.foregroundColor: UIColor(hexString: "#A0A0A0")!, .font: UIFont.systemFont(ofSize: 14)])
        self.searchTextField.attributedPlaceholder = attrStr
        self.searchTextField.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
        
       setupLocalization()

        updateSelectViews()

        
        loadData()
        
    }
    
    func setupLocalization() {
        if self.isIncomplete {
            self.titleLab.text = DDlocal("DDIncomplete")
        } else {
            self.titleLab.text = DDlocal("DDAll_Contacts")
        }
        self.nodataLab.text = DDlocal("DDNo_contacts_to_organize")
        self.nodataLab.adjustsFontSizeToFitWidth = true
    }
    
    func loadData() {
        
        
        DDSharedContactsManager.checkContactAuthorizationStatus { success in
            
            if success {
                
                DispatchQueue.global().async {
                    
                    var tempDataArr: [CNContact] = []
                    if self.isIncomplete {
                        tempDataArr = DDSharedContactsManager.filterIncompleteContacts(contacts: DDContactsManager.shared.fetchAllContacts())
                    } else {
                        tempDataArr = DDContactsManager.shared.fetchAllContacts()
                    }
                    
                    self.dataDic = DDContactsManager.shared.groupContactsByFullName(contacts: tempDataArr)
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
                                        
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
                
            } else {
             
                DDSharedContactsManager.showContactsPermissionsAlert()
                
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

    @IBAction func deleteClick(_ sender: Any) {
        
        if self.selArr.count > 0 {
            let alert = UIAlertController(title: "\(DDlocal("DDDelete")) \(self.selArr.count) \(DDlocal("DDSelected_Contact"))", message: DDlocal("DDItems_will_be_removed_from_the_Contacts"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: DDlocal("DDDelete"), style: .default, handler: { action in
                
                let success = DDSharedContactsManager.deleteContacts(contacts: self.selArr)
                if success {
                    DDshowToast(DDlocal("DDSuccess"))

                    if let handler = self.handler {
                        handler()
                    }
                    
                    self.dataDic = [:]
                    self.keys = []
                    self.searchArr = []
                    self.selArr = []
                    self.tableView.reloadData()
                    self.loadData()
                    
                    
                } else {
                    DDshowToast(DDlocal("DDFail"))
                }
                
                

            }))
            alert.addAction(UIAlertAction(title: DDlocal("DDCancel"), style: .cancel))
            self.present(alert, animated: true)
        }
        
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectClick(_ sender: Any) {
        
        if !self.selBtn.isSelected {
            var allContact: [CNContact] = []
            let allValues = Array(self.dataDic.values)
            for tempArr in allValues {
                for contact in tempArr {
                    allContact.append(contact)
                }
            }
            self.selArr = allContact
        } else {
            self.selArr.removeAll()
        }
        
        self.selBtn.isSelected = !self.selBtn.isSelected
        
        updateSelectViews()
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

    
    // MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        
        DispatchQueue.main.async {
        
            if self.dataDic.count < 1 {
                self.tableView.tableHeaderView = self.nodataView
                self.selBtn.isHidden = true
                self.delBtn.isHidden = true
                self.searchBGView.isHidden = true
                self.view.backgroundColor = UIColor(hexString: "#EBF3FF")
                self.tableView.backgroundColor = UIColor(hexString: "#EBF3FF")
            } else {
                self.tableView.tableHeaderView = UIView()
                self.selBtn.isHidden = false
                self.delBtn.isHidden = false
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "DDContactListCell") as! DDContactListCell
            cell.selectionStyle = .none
            
            let contact = self.searchArr[indexPath.row]
            if contact.fullName.isEmpty {
                cell.titleLab.text = DDSharedContactsManager.getFirstAvailablePhoneNumber(for: contact) ?? ""
            } else {
                cell.titleLab.text = contact.fullName
            }
            cell.contact = contact
            cell.delegate = self
            
            if self.selArr.contains(contact) {
                cell.selBtn.isSelected = true
            } else {
                cell.selBtn.isSelected = false
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DDContactListCell") as! DDContactListCell
            cell.selectionStyle = .none
            let arr = self.dataDic[self.keys[indexPath.section]]
            if let contact = arr?[indexPath.row] {
                
                if contact.fullName.isEmpty {
                    cell.titleLab.text = DDSharedContactsManager.getFirstAvailablePhoneNumber(for: contact) ?? ""
                } else {
                    cell.titleLab.text = contact.fullName
                }
                
                cell.contact = contact
                cell.delegate = self
                
                if self.selArr.contains(contact) {
                    cell.selBtn.isSelected = true
                } else {
                    cell.selBtn.isSelected = false
                }
            
            }
          

            return cell
            
        }
     
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.searchArr.count > 0 {
            
            let contact = self.searchArr[indexPath.row]
            
            let store = CNContactStore()
            
            do {
                // 获取联系人的详细信息
                let contact = try store.unifiedContact(withIdentifier: contact.identifier,
                                                       keysToFetch: [CNContactViewController.descriptorForRequiredKeys()] as [CNKeyDescriptor])
                
                // 创建联系人详情页面
                let contactViewController = CNContactViewController(for: contact)
                
                // 显示的属性
                contactViewController.displayedPropertyKeys = [CNContactThumbnailImageDataKey, CNContactFamilyNameKey,CNContactPreviousFamilyNameKey, CNContactGivenNameKey,CNContactMiddleNameKey, CNContactNicknameKey,CNContactOrganizationNameKey, CNContactJobTitleKey,CNContactDepartmentNameKey, CNContactPhoneNumbersKey, CNContactDatesKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactRelationsKey, CNContactSocialProfilesKey, CNContactInstantMessageAddressesKey, CNContactUrlAddressesKey, CNContactBirthdayKey, CNContactDatesKey, CNContactImageDataKey]
                
                // 推送联系人详情页面到导航控制器
                DDSharePreferences.getCurrentController()?.navigationController?.pushViewController(contactViewController, animated: true)
                
            } catch {
            }
            
            
            
            
        } else {
            let arr = self.dataDic[self.keys[indexPath.section]]
            if let contact = arr?[indexPath.row] {
            
                let store = CNContactStore()

                do {
                    // 获取联系人的详细信息
                    let contact = try store.unifiedContact(withIdentifier: contact.identifier,
                                                           keysToFetch: [CNContactViewController.descriptorForRequiredKeys()] as [CNKeyDescriptor])
                    
                    // 创建联系人详情页面
                    let contactViewController = CNContactViewController(for: contact)
                    
                    // 显示的属性
                    contactViewController.displayedPropertyKeys = [CNContactThumbnailImageDataKey, CNContactFamilyNameKey,CNContactPreviousFamilyNameKey, CNContactGivenNameKey,CNContactMiddleNameKey, CNContactNicknameKey,CNContactOrganizationNameKey, CNContactJobTitleKey,CNContactDepartmentNameKey, CNContactPhoneNumbersKey, CNContactDatesKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactRelationsKey, CNContactSocialProfilesKey, CNContactInstantMessageAddressesKey, CNContactUrlAddressesKey, CNContactBirthdayKey, CNContactDatesKey, CNContactImageDataKey]
                    
                    // 推送联系人详情页面到导航控制器
                    DDSharePreferences.getCurrentController()?.navigationController?.pushViewController(contactViewController, animated: true)

                } catch {
                }

            }

        }
        

        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.searchArr.count > 0 {
            
           return UIView()
            
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
    
    // MARK: - DDContactListCellDelegate
    func DDContactListCellDidClickSelect(selected: Bool, contact: CNContact) {
        
        if selected {
            if !self.selArr.contains(contact) {
                self.selArr.append(contact)
            }
        } else {
            if let index = self.selArr.firstIndex(of: contact) {
                self.selArr.remove(at: index)
            }
        }
        
        updateSelectViews()
        
    }
    
    func updateSelectViews() {
        
        if self.selArr.count > 0 {
            self.delBtn.backgroundColor = UIColor(hexString: "#3863FF")
            self.delBtn.setTitle("\(DDlocal("DDDelete")) \(self.selArr.count) \(DDlocal("DDContacts"))", for: .normal)
        } else {
            self.delBtn.backgroundColor = UIColor(hexString: "#3863FF", alpha: 0.5)
            self.delBtn.setTitle(DDlocal("DDDelete_contacts"), for: .normal)
        }
        
        self.tableView.reloadData()
        
    }
    
    deinit {
        // 记得在销毁时移除观察者
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    

}
