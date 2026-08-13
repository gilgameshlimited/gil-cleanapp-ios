import UIKit
import Contacts
import ContactsUI

protocol DDDuplicateContactsGroupCellDelegate: AnyObject {
    func DDDuplicateContactsGroupCellDidClickPreview(contactsArr: [CNContact], indexPath: IndexPath)
    func DDDuplicateContactsGroupCellDidClickMerge(contactsArr: [CNContact], indexPath: IndexPath)
}

class DDDuplicateContactsGroupCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, DDDuplicateContactsCellDelegate {
    
    var delegate: DDDuplicateContactsGroupCellDelegate?

    var contactsArr: [CNContact] = [] {
        didSet {
            
            if let contact = contactsArr.first {
                
                let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                self.titleLab.text = fullName

            }

            self.tableView.reloadData()
        }
    }
    
    var selArr: [CNContact] = []
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    @IBOutlet weak var mergeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var previewBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "DDDuplicateContactsCell", bundle: nil), forCellReuseIdentifier: "DDDuplicateContactsCell")
        
    }
    
    @IBAction func selectClick(_ sender: Any) {
        
        if self.selBtn.isSelected {
            
            self.selArr.removeAll()
            
        } else {
            
            self.selArr = self.contactsArr
            
        }
        
        self.selBtn.isSelected = !self.selBtn.isSelected
        
        self.tableView.reloadData()
        
        if self.selArr.count > 1 {
            self.mergeBtn.setTitle("\(DDlocal("DDMerge")) \(self.selArr.count) \(DDlocal("DDContacts"))", for: .normal)
            self.mergeBtn.backgroundColor = UIColor(hexString: "#3863FF")
            self.previewBtn.backgroundColor = UIColor(hexString: "#3863FF")
            
        } else {
            
            self.mergeBtn.setTitle("\(DDlocal("DDMerge")) 0 \(DDlocal("DDContacts"))", for: .normal)
            self.mergeBtn.backgroundColor = UIColor(hexString: "#3863FF", alpha: 0.5)
            self.previewBtn.backgroundColor = UIColor(hexString: "#3863FF", alpha: 0.5)

        }
        
        
    }
    
    @IBAction func previewClick(_ sender: Any) {
        
        if self.selArr.count > 1 {
            delegate?.DDDuplicateContactsGroupCellDidClickPreview(contactsArr: self.selArr, indexPath: self.indexPath)
        }
        
        
    }
    
    @IBAction func mergeClick(_ sender: Any) {
        if self.selArr.count > 1 {
            
            delegate?.DDDuplicateContactsGroupCellDidClickMerge(contactsArr: self.selArr, indexPath: self.indexPath)
            
        }
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDDuplicateContactsCell") as! DDDuplicateContactsCell
        cell.selectionStyle = .none
        let contact = self.contactsArr[indexPath.row]
        
        let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
        cell.titleLab.text = fullName
        let phoneArr = DDSharedContactsManager.getAllPhoneNumbers(from: contact)
        cell.subTitleLab.text = phoneArr.joined(separator: ",")
        cell.indexPath = indexPath
        cell.delegate = self
        
        if self.selArr.contains(contact) {
            cell.selBtn.isSelected = true
        } else {
            cell.selBtn.isSelected = false
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contact = self.contactsArr[indexPath.row]
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func DDDuplicateContactsCellDidSelected(indexPath: IndexPath, selected: Bool) {
        
        let contact = self.contactsArr[indexPath.row]

        if selected {
            
            self.selArr.append(contact)
            
        } else {
        
            if let index = self.selArr.firstIndex(of: contact) {
                self.selArr.remove(at: index)
            }
            
        }
        
        if self.selArr.count > 1 {
            self.mergeBtn.setTitle("\(DDlocal("DDMerge")) \(self.selArr.count) \(DDlocal("DDContacts"))", for: .normal)
            self.mergeBtn.backgroundColor = UIColor(hexString: "#3863FF")
            self.previewBtn.backgroundColor = UIColor(hexString: "#3863FF")
            
        } else {
            
            self.mergeBtn.setTitle("\(DDlocal("DDMerge")) 0 \(DDlocal("DDContacts"))", for: .normal)
            self.mergeBtn.backgroundColor = UIColor(hexString: "#3863FF", alpha: 0.5)
            self.previewBtn.backgroundColor = UIColor(hexString: "#3863FF", alpha: 0.5)

        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
