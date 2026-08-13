import UIKit
import Contacts

let DDSharedContactsManager = DDContactsManager.shared

class DDContactsManager: NSObject {
    
    static let shared = DDContactsManager()
    
    func saveSecretContacts(contacts: [CNContact]) {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("contacts.archive")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: contacts, requiringSecureCoding: false)
            try data.write(to: fileURL)
        } catch {
        }
    }
    
    func loadSecretContacts() -> [CNContact] {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else { return [] }
        
        let fileURL = documentDirectory.appendingPathComponent("contacts.archive")
        
        do {
            let data = try Data(contentsOf: fileURL)
            if let contacts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [CNContact] {
                return contacts
            }
        } catch {
        }
        
        return []
    }

    
    
    func getFirstAvailablePhoneNumber(for contact: CNContact) -> String? {
        // 遍历联系人所有的电话号码
        for phoneNumber in contact.phoneNumbers {
            // 取出手机号并检查是否为空
            let number = phoneNumber.value.stringValue
            if !number.isEmpty {
                return number // 返回第一个非空的手机号
            }
        }
        return nil // 如果所有号码都为空，返回 nil
    }

    
    func fetchAllContacts() -> [CNContact] {
        // 创建用于存储所有联系人的数组
        var contacts: [CNContact] = []
        // 获取联系人存储
        let contactStore = CNContactStore()
        
        // 定义要获取的字段（如名字、姓氏、电话号码等）
        var keysToFetch = [CNContactThumbnailImageDataKey, CNContactFamilyNameKey,CNContactPreviousFamilyNameKey, CNContactGivenNameKey,CNContactMiddleNameKey, CNContactNicknameKey,CNContactOrganizationNameKey, CNContactJobTitleKey,CNContactDepartmentNameKey, CNContactPhoneNumbersKey, CNContactDatesKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactRelationsKey, CNContactSocialProfilesKey, CNContactInstantMessageAddressesKey, CNContactUrlAddressesKey, CNContactBirthdayKey, CNContactDatesKey, CNContactImageDataKey] as [CNKeyDescriptor]

        
        keysToFetch.append(CNContactFormatter.descriptorForRequiredKeys(for: .fullName))
        
        // 创建联系人获取请求
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        
        do {
            // 枚举联系人并将其添加到数组中
            try contactStore.enumerateContacts(with: fetchRequest) { (contact, stop) in
                contacts.append(contact)
            }
        } catch {
        }

        
        return contacts
    }
    
    func filterIncompleteContacts(contacts: [CNContact]) -> [CNContact] {
        let filteredContacts = contacts.filter { contact in
            // 检查 fullName、电话号码或电子邮件是否为空
            let fullNameIsEmpty = contact.fullName.isEmpty
            let phoneNumbersAreEmpty = contact.phoneNumbers.isEmpty
            let emailAddressesAreEmpty = contact.emailAddresses.isEmpty
            
            // 只要 fullName、电话号码或者电子邮件任一项为空，就返回 true
            return fullNameIsEmpty || (phoneNumbersAreEmpty && emailAddressesAreEmpty)
        }
        
        return filteredContacts
    }
    
    func showContactsPermissionsAlert() {
        // 获取授权状态
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        // 如果没有授权，提示用户去设置中授权
        if status != .authorized {
            DispatchQueue.main.async {
                
                let alertVC = UIAlertController(
                    title: DDlocal("DDNo_contact_permissions"),
                    message: DDlocal("DDPlease_allow_the_use_of_your_contacts"),
                    preferredStyle: .alert
                )
                
                let settingsAction = UIAlertAction(title: DDlocal("DDSetting"), style: .default) { _ in
                    if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
                    }
                }
                
                alertVC.addAction(settingsAction)
                alertVC.addAction(UIAlertAction(title: DDlocal("DDCancel"), style: .cancel, handler: nil))
                
                // 将 "Setting" 动作设置为首选
                alertVC.preferredAction = settingsAction
                
                // 显示弹出框
                DDSharePreferences.getCurrentController()?.present(alertVC, animated: true, completion: nil)
            }
        }
    }

    func checkContactAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        // 获取通讯录的授权状态
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .authorized:
            // 已授权
            completion(true)
            
        case .notDetermined:
            // 用户尚未作出选择，请求访问权限
            CNContactStore().requestAccess(for: .contacts) { granted, error in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
            
        case .denied, .restricted:
            // 用户拒绝或受限制
            completion(false)
            
        @unknown default:
            completion(false)
        }
    }
    
    func getAllPhoneNumbers(from contact: CNContact) -> [String] {
        var phoneNumbers: [String] = []

        for phoneNumber in contact.phoneNumbers {
            // 获取CNPhoneNumber实例
            let number = phoneNumber.value.stringValue
            phoneNumbers.append(number)
        }
        
        return phoneNumbers
    }

    // 筛选出名字重复的联系人，并返回二维数组
    func findDuplicateNameContacts(contacts: [CNContact]) -> [[CNContact]] {
        var nameDict: [String: [CNContact]] = [:]
        
        // 遍历联系人数组，将联系人按全名分组
        for contact in contacts {
            // 获取联系人的全名
            let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
            
            // 将联系人添加到对应的全名组中
            nameDict[fullName, default: []].append(contact)
        }
        
        // 过滤只包含重复名字的分组
        let duplicateNames = nameDict.filter { $0.value.count > 1 }
        
        // 提取出重复名字的联系人组，并返回
        return Array(duplicateNames.values)
    }
    
    
    func mergeContacts(_ contacts: [CNContact]) -> CNMutableContact {
        let mergedContact = CNMutableContact()

        // 合并姓名 (根据需要自行调整逻辑)
        
        var namePrefix: [String] = []
        var givenName: [String] = []
        var middleName: [String] = []
        var familyName: [String] = []
        var previousFamilyName: [String] = []
        var nameSuffix: [String] = []
        var nickname: [String] = []
        var organizationName: [String] = []
        var departmentName: [String] = []
        var jobTitle: [String] = []

        
        
        for contact in contacts {
            
            if contact.namePrefix.validTrimSpaces {
                namePrefix.append(contact.namePrefix)
            }
            if contact.givenName.validTrimSpaces {
                givenName.append(contact.givenName)
            }
            if contact.middleName.validTrimSpaces {
                middleName.append(contact.middleName)
            }
            if contact.familyName.validTrimSpaces {
                familyName.append(contact.familyName)
            }
            if contact.previousFamilyName.validTrimSpaces {
                previousFamilyName.append(contact.previousFamilyName)
            }
            if contact.nameSuffix.validTrimSpaces {
                nameSuffix.append(contact.nameSuffix)
            }
            if contact.nickname.validTrimSpaces {
                nickname.append(contact.nickname)
            }
            if contact.organizationName.validTrimSpaces {
                organizationName.append(contact.organizationName)
            }
            if contact.departmentName.validTrimSpaces {
                departmentName.append(contact.departmentName)
            }
            if contact.jobTitle.validTrimSpaces {
                jobTitle.append(contact.jobTitle)
            }
            
        }

        // 合并姓名 (根据需要自行调整逻辑)
        mergedContact.namePrefix = namePrefix.first ?? ""
        mergedContact.givenName = givenName.first ?? ""
        mergedContact.middleName = middleName.first ?? ""
        mergedContact.familyName = familyName.first ?? ""
        mergedContact.previousFamilyName = previousFamilyName.first ?? ""
        mergedContact.nameSuffix = nameSuffix.first ?? ""
        mergedContact.nickname = nickname.first ?? ""
        mergedContact.organizationName = organizationName.first ?? ""
        mergedContact.departmentName = departmentName.first ?? ""
        mergedContact.jobTitle = jobTitle.first ?? ""

        
        // 合并电话号码
        var phoneNumbers: [CNLabeledValue<CNPhoneNumber>] = []
        for contact in contacts {
            phoneNumbers.append(contentsOf: contact.phoneNumbers)
        }
        mergedContact.phoneNumbers = phoneNumbers
        
        // 合并电子邮件
        var emailAddresses: [CNLabeledValue<NSString>] = []
        for contact in contacts {
            emailAddresses.append(contentsOf: contact.emailAddresses)
        }
        mergedContact.emailAddresses = emailAddresses
        
        // 合并地址
        var postalAddresses: [CNLabeledValue<CNPostalAddress>] = []
        for contact in contacts {
            postalAddresses.append(contentsOf: contact.postalAddresses)
        }
        mergedContact.postalAddresses = postalAddresses
        
        // 合并社交账户
        var socialProfiles: [CNLabeledValue<CNSocialProfile>] = []
        for contact in contacts {
            socialProfiles.append(contentsOf: contact.socialProfiles)
        }
        mergedContact.socialProfiles = socialProfiles
        
        // 合并即时通讯
        var instantMessageAddresses: [CNLabeledValue<CNInstantMessageAddress>] = []
        for contact in contacts {
            instantMessageAddresses.append(contentsOf: contact.instantMessageAddresses)
        }
        mergedContact.instantMessageAddresses = instantMessageAddresses
        
        // 合并URL地址
        var urlAddresses: [CNLabeledValue<NSString>] = []
        for contact in contacts {
            urlAddresses.append(contentsOf: contact.urlAddresses)
        }
        mergedContact.urlAddresses = urlAddresses
        
        // 合并生日（使用第一个联系人的生日）
        if let birthday = contacts.first?.birthday {
            mergedContact.birthday = birthday
        }
        
        // 合并重要日期
        var dates: [CNLabeledValue<NSDateComponents>] = []
        for contact in contacts {
            dates.append(contentsOf: contact.dates)
        }
        mergedContact.dates = dates
        
        // 合并头像（使用第一个联系人的头像）
        if let imageData = contacts.first?.imageData {
            mergedContact.imageData = imageData
        }

        return mergedContact
    }

    
    func deleteContacts(contacts: [CNContact]) -> Bool {
        
        // 创建 CNContactStore 实例
        let contactStore = CNContactStore()

        // 创建 CNSaveRequest
        let saveRequest = CNSaveRequest()

        // 遍历所有需要删除的联系人
        for contact in contacts {
            // 将 CNContact 转换为 CNMutableContact
            let mutableContact = contact.mutableCopy() as! CNMutableContact

            // 将删除请求添加到 saveRequest 中
            saveRequest.delete(mutableContact)
        }

        // 执行删除操作
        do {
            try contactStore.execute(saveRequest)
            
            return true
        } catch {
            return false
        }

    }

    
    func groupContactsByFullName(contacts: [CNContact]) -> [String: [CNContact]] {
        // 用于存储分组结果的字典
        var groupedContacts: [String: [CNContact]] = [:]
        
        // 初始化字母表 A-Z
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let digits = "0123456789"
        
        // 初始化 A-Z、1~9、# 分组
        for letter in letters {
            groupedContacts[String(letter)] = []
        }
        groupedContacts["1~9"] = [] // 数字分组
        groupedContacts["#"] = []   // 特殊字符分组
        
        for contact in contacts {
            // 获取 fullName 并提取首字符
            let fullName = contact.fullName
            
            // 如果 fullName 为空，直接将联系人放入 # 分组
            if fullName.isEmpty {
                groupedContacts["#"]?.append(contact)
                continue
            }
            
            guard let firstChar = fullName.prefix(1).uppercased().first else {
                continue
            }
            
            // 判断首字母是否是字母
            if letters.contains(firstChar) {
                groupedContacts[String(firstChar)]?.append(contact)
            }
            // 判断是否是数字
            else if digits.contains(firstChar) {
                groupedContacts["1~9"]?.append(contact)
            }
            // 非字母、数字的放入 # 分组
            else {
                groupedContacts["#"]?.append(contact)
            }
        }
        
        // 对每个分组内的联系人进行排序
        for (key, _) in groupedContacts {
            groupedContacts[key]?.sort { $0.fullName < $1.fullName }
        }
        
        // 过滤掉空数组的分组
        let nonEmptyGroupedContacts = groupedContacts.filter { !$0.value.isEmpty }
        
        return nonEmptyGroupedContacts
    }

    
    func conversionMutableContact(_ contact: CNContact) -> CNMutableContact {
        let mutableContact = CNMutableContact()

        // 合并姓名 (根据需要自行调整逻辑)
        // 复制 CNContact 的属性到 CNMutableContact
        mutableContact.namePrefix = contact.namePrefix
        mutableContact.givenName = contact.givenName
        mutableContact.middleName = contact.middleName
        mutableContact.familyName = contact.familyName
        mutableContact.previousFamilyName = contact.previousFamilyName
        mutableContact.nameSuffix = contact.nameSuffix
        mutableContact.nickname = contact.nickname
        mutableContact.organizationName = contact.organizationName
        mutableContact.departmentName = contact.departmentName
        mutableContact.jobTitle = contact.jobTitle
        mutableContact.phoneNumbers = contact.phoneNumbers
        mutableContact.emailAddresses = contact.emailAddresses
        mutableContact.postalAddresses = contact.postalAddresses
        mutableContact.socialProfiles = contact.socialProfiles
        mutableContact.instantMessageAddresses = contact.instantMessageAddresses
        mutableContact.urlAddresses = contact.urlAddresses
        mutableContact.birthday = contact.birthday
        mutableContact.dates = contact.dates
        mutableContact.imageData = contact.imageData


        return mutableContact
        
    }

}


extension CNContact {
    var fullName: String {
        let fullName = CNContactFormatter.string(from: self, style: .fullName) ?? ""
        return fullName
    }
}
