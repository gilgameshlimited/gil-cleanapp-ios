import UIKit

class DDPreferences: NSObject {
    
    static let shared = DDPreferences()
    
    var secretAlbumRemoveOriginalPhotos: Bool {
        
        get {
            return UserDefaults.standard.bool(forKey: "secretAlbumRemoveOriginalPhotos")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "secretAlbumRemoveOriginalPhotos")
        }
        
        
    }
    
    var secretContactsRemoveOriginalContacts: Bool {
        
        get {
            return UserDefaults.standard.bool(forKey: "secretContactsRemoveOriginalContacts")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "secretContactsRemoveOriginalContacts")
        }
        
        
    }
    
    var openPrivacyLock: Bool {
        
        get {
            return UserDefaults.standard.bool(forKey: "openPrivacyLock")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "openPrivacyLock")
        }
        
        
    }
    
    func installTabBarControllerToWindow() {
        
        DDAppDelegate?.window?.rootViewController = DDTabBarController()
    }
    
    func checkSecretAlbumFirstRun() -> Bool {
        
        //主程序版本号
        let infoDic = Bundle.main.infoDictionary
        let version = infoDic?["CFBundleShortVersionString"] as! String
        let hasBeenLaunchedOfNewVersion = "hasBeenLaunchedSecretAlbumOfNewVersion"
        let lastVersion = UserDefaults.standard.string(forKey: hasBeenLaunchedOfNewVersion)
        
        if lastVersion == nil {
            //存储本次进入app时的版本号
            UserDefaults.standard.set(version, forKey: hasBeenLaunchedOfNewVersion)
            
            return true
        } else {
            //版本号比较
            let isFirstLaunchOfNewVersion = version != (lastVersion!)
            if isFirstLaunchOfNewVersion {
                
                
                UserDefaults.standard.set(version, forKey: hasBeenLaunchedOfNewVersion)
            }
            
            return isFirstLaunchOfNewVersion
        }
        
    }
    
    func checkSecretContactsFirstRun() -> Bool {
        
        //主程序版本号
        let infoDic = Bundle.main.infoDictionary
        let version = infoDic?["CFBundleShortVersionString"] as! String
        let hasBeenLaunchedOfNewVersion = "hasBeenLaunchedSecretContactsOfNewVersion"
        let lastVersion = UserDefaults.standard.string(forKey: hasBeenLaunchedOfNewVersion)
        
        if lastVersion == nil {
            //存储本次进入app时的版本号
            UserDefaults.standard.set(version, forKey: hasBeenLaunchedOfNewVersion)
            
            return true
        } else {
            //版本号比较
            let isFirstLaunchOfNewVersion = version != (lastVersion!)
            if isFirstLaunchOfNewVersion {
                
                
                UserDefaults.standard.set(version, forKey: hasBeenLaunchedOfNewVersion)
            }
            
            return isFirstLaunchOfNewVersion
        }
        
    }

    
    //获取当前屏幕显示的viewcontroller
    func getCurrentController() -> UIViewController? {
        
        guard var window = UIApplication.shared.keyWindow else {
            return nil
        }

        if window.windowLevel != .normal {

            let windows = UIApplication.shared.windows

            for tmpWin in windows {

                if tmpWin.windowLevel == .normal{

                    window = tmpWin

                    break

                }

            }

        }

        guard var result = window.rootViewController else {
            return nil
        }

        while result.presentedViewController != nil {

            result = result.presentedViewController!

        }
        
        if let tabBarController = result as? UITabBarController, tabBarController.selectedViewController != nil {
            
            result = tabBarController.selectedViewController!

        }

        if let navigationController = result as? UINavigationController, navigationController.topViewController != nil {
            
            result = navigationController.topViewController!

        }
        

        return result
        
        
    }
    
    func getTxtFilePath(contentText: String) -> String? {
        
        // 获取应用程序的文档目录路径
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let fileStr = "authenticator_\(String.getFilePathTimeString()).txt"
        let filePath = temporaryDirectory.appendingPathComponent(fileStr).path
        
        // 文件不存在
        if FileManager.default.fileExists(atPath: filePath) {
            
            try? FileManager.default.removeItem(atPath: filePath)
            
        }
        
        if FileManager.default.createFile(atPath: filePath, contents: nil) {
            
            do {
                
                try contentText.write(toFile: filePath, atomically: true, encoding: .utf8)
                
                return filePath

            } catch {
                

                
                return nil
                
            }
            
        } else {
            return nil
        }
        
        
    }
    
    

    
    
    func getCountryData() -> [[String: Any]] {
        
        let countryArray = [
            
            ["countryName": "Saudi Arabia", "countryFlagName": "VV-SA", "countryCode": "+966", "letterCode": "SA"],
            ["countryName": "United Arab Emirates", "countryFlagName": "VV-AE", "countryCode": "+971", "letterCode": "AE"],
            ["countryName": "Qatar", "countryFlagName": "VV-QA", "countryCode": "+974", "letterCode": "QA"],
            ["countryName": "Kuwait", "countryFlagName": "VV-KW", "countryCode": "+965", "letterCode": "KW"],
            ["countryName": "Oman", "countryFlagName": "VV-OM", "countryCode": "+968", "letterCode": "OM"],
            ["countryName": "United States of America", "countryFlagName": "VV-US", "countryCode": "+1", "letterCode": "US"],
            ["countryName": "United Kiongdom", "countryFlagName": "VV-GB", "countryCode": "+44", "letterCode": "GB"],
            ["countryName": "Canada", "countryFlagName": "VV-CA", "countryCode": "+1", "letterCode": "CA"],
            ["countryName": "Afghanistan", "countryFlagName": "VV-AF", "countryCode": "+93", "letterCode": "AF"],
            ["countryName": "Albania", "countryFlagName": "VV-AL", "countryCode": "+355", "letterCode": "AL"],
            ["countryName": "Algeria", "countryFlagName": "VV-DZ", "countryCode": "+213", "letterCode": "DZ"],
            ["countryName": "Andorra", "countryFlagName": "VV-AD", "countryCode": "+376", "letterCode": "AD"],
            ["countryName": "Angola", "countryFlagName": "VV-AO", "countryCode": "+244", "letterCode": "AO"],
            ["countryName": "Anguilla", "countryFlagName": "VV-AI", "countryCode": "+1264", "letterCode": "AI"],
            ["countryName": "Antigua and Barbuda", "countryFlagName": "VV-AG", "countryCode": "+1268", "letterCode": "AG"],
            ["countryName": "Argentina", "countryFlagName": "VV-AR", "countryCode": "+54", "letterCode": "AR"],
            ["countryName": "Armenia", "countryFlagName": "VV-AM", "countryCode": "+374", "letterCode": "AM"],
            ["countryName": "Australia", "countryFlagName": "VV-AU", "countryCode": "+61", "letterCode": "AU"],
            ["countryName": "Austria", "countryFlagName": "VV-AT", "countryCode": "+43", "letterCode": "AT"],
            ["countryName": "Azerbaijan", "countryFlagName": "VV-AZ", "countryCode": "+994", "letterCode": "AZ"],
            ["countryName": "Bahamas", "countryFlagName": "VV-BS", "countryCode": "+1242", "letterCode": "BS"],
            ["countryName": "Bahrain", "countryFlagName": "VV-BH", "countryCode": "+973", "letterCode": "BH"],
            ["countryName": "Bangladesh", "countryFlagName": "VV-BD", "countryCode": "+880", "letterCode": "BD"],
            ["countryName": "Barbados", "countryFlagName": "VV-DD", "countryCode": "+1246", "letterCode": "DD"],
            ["countryName": "Belarus", "countryFlagName": "VV-BY", "countryCode": "+375", "letterCode": "BY"],
            ["countryName": "Belgium", "countryFlagName": "VV-BE", "countryCode": "+32", "letterCode": "BE"],
            ["countryName": "Belize", "countryFlagName": "VV-BZ", "countryCode": "+501", "letterCode": "BZ"],
            ["countryName": "Benin", "countryFlagName": "VV-BJ", "countryCode": "+229", "letterCode": "BJ"],
            ["countryName": "Bermuda Is.", "countryFlagName": "VV-BM", "countryCode": "+1441", "letterCode": "BM"],
            ["countryName": "Bolivia", "countryFlagName": "VV-BO", "countryCode": "+591", "letterCode": "BO"],
            ["countryName": "Botswana", "countryFlagName": "VV-BW", "countryCode": "+267", "letterCode": "BW"],
            ["countryName": "Brazil", "countryFlagName": "VV-BR", "countryCode": "+55", "letterCode": "BR"],
            ["countryName": "Brunei", "countryFlagName": "VV-BN", "countryCode": "+673", "letterCode": "BN"],
            ["countryName": "Bulgaria", "countryFlagName": "VV-BG", "countryCode": "+359", "letterCode": "BG"],
            ["countryName": "Burkina-faso", "countryFlagName": "VV-BF", "countryCode": "+226", "letterCode": "BF"],
            ["countryName": "Burma", "countryFlagName": "VV-MM", "countryCode": "+95", "letterCode": "MM"],
            ["countryName": "Burundi", "countryFlagName": "VV-BI", "countryCode": "+257", "letterCode": "BI"],
            ["countryName": "Cameroon", "countryFlagName": "VV-CM", "countryCode": "+237", "letterCode": "CM"],
            ["countryName": "Cayman Is.", "countryFlagName": "VV-KY", "countryCode": "+1345", "letterCode": "KY"],
            ["countryName": "Central African Republic", "countryFlagName": "VV-CF", "countryCode": "+236", "letterCode": "CF"],
            ["countryName": "Chad", "countryFlagName": "VV-TD", "countryCode": "+235", "letterCode": "TD"],
            ["countryName": "Chile", "countryFlagName": "VV-CL", "countryCode": "+56", "letterCode": "CL"],
            ["countryName": "China", "countryFlagName": "VV-CN", "countryCode": "+86", "letterCode": "CN"],
            ["countryName": "Colombia", "countryFlagName": "VV-CO", "countryCode": "+57", "letterCode": "CO"],
            ["countryName": "Congo", "countryFlagName": "VV-CG", "countryCode": "+242", "letterCode": "CG"],
            ["countryName": "Congo-kinshasa", "countryFlagName": "VV-CD", "countryCode": "+243", "letterCode": "CD"],
            ["countryName": "Cook Is.", "countryFlagName": "VV-CK", "countryCode": "+682", "letterCode": "CK"],
            ["countryName": "Costa Rica", "countryFlagName": "VV-CR", "countryCode": "+506", "letterCode": "CR"],
            ["countryName": "Cuba", "countryFlagName": "VV-CU", "countryCode": "+53", "letterCode": "CU"],
            ["countryName": "Cyprus", "countryFlagName": "VV-CY", "countryCode": "+357", "letterCode": "CY"],
            ["countryName": "Czech Republic", "countryFlagName": "VV-CZ", "countryCode": "+420", "letterCode": "CZ"],
            ["countryName": "Denmark", "countryFlagName": "VV-DK", "countryCode": "+45", "letterCode": "DK"],
            ["countryName": "Djibouti", "countryFlagName": "VV-DJ", "countryCode": "+253", "letterCode": "DJ"],
            ["countryName": "Dominica Rep.", "countryFlagName": "VV-DO", "countryCode": "+1890", "letterCode": "DO"],
            ["countryName": "Ecuador", "countryFlagName": "VV-EC", "countryCode": "+593", "letterCode": "EC"],
            ["countryName": "Egypt", "countryFlagName": "VV-EG", "countryCode": "+20", "letterCode": "EG"],
            ["countryName": "EI Salvador", "countryFlagName": "VV-SV", "countryCode": "+503", "letterCode": "SV"],
            ["countryName": "Estonia", "countryFlagName": "VV-EE", "countryCode": "+372", "letterCode": "EE"],
            ["countryName": "Ethiopia", "countryFlagName": "VV-ET", "countryCode": "+251", "letterCode": "ET"],
            ["countryName": "Fiji", "countryFlagName": "VV-FJ", "countryCode": "+679", "letterCode": "FJ"],
            ["countryName": "Finland", "countryFlagName": "VV-FI", "countryCode": "+358", "letterCode": "FI"],
            ["countryName": "France", "countryFlagName": "VV-FR", "countryCode": "+33", "letterCode": "FR"],
            ["countryName": "French Polynesia", "countryFlagName": "VV-PF", "countryCode": "+689", "letterCode": "PF"],
            ["countryName": "Gabon", "countryFlagName": "VV-GA", "countryCode": "+241", "letterCode": "GA"],
            ["countryName": "Gambia", "countryFlagName": "VV-GM", "countryCode": "+220", "letterCode": "GM"],
            ["countryName": "Georgia", "countryFlagName": "VV-GE", "countryCode": "+995", "letterCode": "GE"],
            ["countryName": "Germany", "countryFlagName": "VV-DE", "countryCode": "+49", "letterCode": "DE"],
            ["countryName": "Ghana", "countryFlagName": "VV-GH", "countryCode": "+233", "letterCode": "GH"],
            ["countryName": "Gibraltar", "countryFlagName": "VV-GI", "countryCode": "+350", "letterCode": "GI"],
            ["countryName": "Greece", "countryFlagName": "VV-GR", "countryCode": "+30", "letterCode": "GR"],
            ["countryName": "Grenada", "countryFlagName": "VV-GD", "countryCode": "+1809", "letterCode": "GD"],
            ["countryName": "Guam", "countryFlagName": "VV-GU", "countryCode": "+1671", "letterCode": "GU"],
            ["countryName": "Guatemala", "countryFlagName": "VV-GT", "countryCode": "+502", "letterCode": "GT"],
            ["countryName": "Guinea", "countryFlagName": "VV-GN", "countryCode": "+224", "letterCode": "GN"],
            ["countryName": "Guyana", "countryFlagName": "VV-GY", "countryCode": "+592", "letterCode": "GY"],
            ["countryName": "Haiti", "countryFlagName": "VV-HT", "countryCode": "+509", "letterCode": "HT"],
            ["countryName": "Honduras", "countryFlagName": "VV-HN", "countryCode": "+504", "letterCode": "HN"],
            ["countryName": "Hongkong", "countryFlagName": "VV-HK", "countryCode": "+852", "letterCode": "HK"],
            ["countryName": "Hungary", "countryFlagName": "VV-HU", "countryCode": "+36", "letterCode": "HU"],
            ["countryName": "Iceland", "countryFlagName": "VV-IS", "countryCode": "+354", "letterCode": "IS"],
            ["countryName": "India", "countryFlagName": "VV-IN", "countryCode": "+91", "letterCode": "IN"],
            ["countryName": "Indonesia", "countryFlagName": "VV-ID", "countryCode": "+62", "letterCode": "ID"],
            ["countryName": "Iran", "countryFlagName": "VV-IR", "countryCode": "+98", "letterCode": "IR"],
            ["countryName": "Iraq", "countryFlagName": "VV-IQ", "countryCode": "+964", "letterCode": "IQ"],
            ["countryName": "Ireland", "countryFlagName": "VV-IE", "countryCode": "+353", "letterCode": "IE"],
            ["countryName": "Israel", "countryFlagName": "VV-IL", "countryCode": "+972", "letterCode": "IL"],
            ["countryName": "Italy", "countryFlagName": "VV-IT", "countryCode": "+39", "letterCode": "IT"],
            ["countryName": "Ivory Coast", "countryFlagName": "VV-KT", "countryCode": "+225", "letterCode": "KT"],
            ["countryName": "Jamaica", "countryFlagName": "VV-JM", "countryCode": "+1876", "letterCode": "JM"],
            ["countryName": "Japan", "countryFlagName": "VV-JP", "countryCode": "+81", "letterCode": "JP"],
            ["countryName": "Jordan", "countryFlagName": "VV-JO", "countryCode": "+962", "letterCode": "JO"],
            ["countryName": "Kampuchea (Cambodia)", "countryFlagName": "VV-KH", "countryCode": "+855", "letterCode": "KH"],
            ["countryName": "Kazakstan", "countryFlagName": "VV-KZ", "countryCode": "+327", "letterCode": "KZ"],
            ["countryName": "Kenya", "countryFlagName": "VV-KE", "countryCode": "+254", "letterCode": "KE"],
            ["countryName": "Korea", "countryFlagName": "VV-KR", "countryCode": "+82", "letterCode": "KR"],
            ["countryName": "Kyrgyzstan", "countryFlagName": "VV-KG", "countryCode": "+331", "letterCode": "KG"],
            ["countryName": "Laos", "countryFlagName": "VV-LA", "countryCode": "+856", "letterCode": "LA"],
            ["countryName": "Latvia", "countryFlagName": "VV-LV", "countryCode": "+371", "letterCode": "LV"],
            ["countryName": "Lebanon", "countryFlagName": "VV-LB", "countryCode": "+961", "letterCode": "LB"],
            ["countryName": "Lesotho", "countryFlagName": "VV-LS", "countryCode": "+266", "letterCode": "LS"],
            ["countryName": "Liberia", "countryFlagName": "VV-LR", "countryCode": "+231", "letterCode": "LR"],
            ["countryName": "Libya", "countryFlagName": "VV-LY", "countryCode": "+218", "letterCode": "LY"],
            ["countryName": "Liechtenstein", "countryFlagName": "VV-LI", "countryCode": "+423", "letterCode": "LI"],
            ["countryName": "Lithuania", "countryFlagName": "VV-LT", "countryCode": "+370", "letterCode": "LT"],
            ["countryName": "Luxembourg", "countryFlagName": "VV-LU", "countryCode": "+352", "letterCode": "LU"],
            ["countryName": "Macao", "countryFlagName": "VV-MO", "countryCode": "+853", "letterCode": "MO"],
            ["countryName": "Madagascar", "countryFlagName": "VV-MG", "countryCode": "+261", "letterCode": "MG"],
            ["countryName": "Malawi", "countryFlagName": "VV-MW", "countryCode": "+265", "letterCode": "MW"],
            ["countryName": "Malaysia", "countryFlagName": "VV-MY", "countryCode": "+60", "letterCode": "MY"],
            ["countryName": "Maldives", "countryFlagName": "VV-MV", "countryCode": "+960", "letterCode": "MV"],
            ["countryName": "Mali", "countryFlagName": "VV-ML", "countryCode": "+223", "letterCode": "ML"],
            ["countryName": "Malta", "countryFlagName": "VV-MT", "countryCode": "+356", "letterCode": "MT"],
            ["countryName": "Mauritius", "countryFlagName": "VV-MU", "countryCode": "+230", "letterCode": "MU"],
            ["countryName": "Mexico", "countryFlagName": "VV-MX", "countryCode": "+52", "letterCode": "MX"],
            ["countryName": "Republic of Moldova", "countryFlagName": "VV-MD", "countryCode": "+373", "letterCode": "MD"],
            ["countryName": "Monaco", "countryFlagName": "VV-MC", "countryCode": "+377", "letterCode": "MC"],
            ["countryName": "Mongolia", "countryFlagName": "VV-MN", "countryCode": "+976", "letterCode": "MN"],
            ["countryName": "Montserrat Is", "countryFlagName": "VV-MS", "countryCode": "+1664", "letterCode": "MS"],
            ["countryName": "MoroDDo", "countryFlagName": "VV-MA", "countryCode": "+212", "letterCode": "MA"],
            ["countryName": "Mozambique", "countryFlagName": "VV-MZ", "countryCode": "+258", "letterCode": "MZ"],
            ["countryName": "Namibia", "countryFlagName": "VV-NA", "countryCode": "+264", "letterCode": "NA"],
            ["countryName": "Nauru", "countryFlagName": "VV-NR", "countryCode": "+674", "letterCode": "NR"],
            ["countryName": "Nepal", "countryFlagName": "VV-NP", "countryCode": "+977", "letterCode": "NP"],
            ["countryName": "Netherlands", "countryFlagName": "VV-NL", "countryCode": "+31", "letterCode": "NL"],
            ["countryName": "New Zealand", "countryFlagName": "VV-NZ", "countryCode": "+64", "letterCode": "NZ"],
            ["countryName": "Nicaragua", "countryFlagName": "VV-NI", "countryCode": "+505", "letterCode": "NI"],
            ["countryName": "Niger", "countryFlagName": "VV-NE", "countryCode": "+227", "letterCode": "NE"],
            ["countryName": "Nigeria", "countryFlagName": "VV-NG", "countryCode": "+234", "letterCode": "NG"],
            ["countryName": "North Korea", "countryFlagName": "VV-KP", "countryCode": "+850", "letterCode": "KP"],
            ["countryName": "Norway", "countryFlagName": "VV-NO", "countryCode": "+47", "letterCode": "NO"],
            ["countryName": "Pakistan", "countryFlagName": "VV-PK", "countryCode": "+92", "letterCode": "PK"],
            ["countryName": "Panama", "countryFlagName": "VV-PA", "countryCode": "+507", "letterCode": "PA"],
            ["countryName": "Papua New Cuinea", "countryFlagName": "VV-PG", "countryCode": "+675", "letterCode": "PG"],
            ["countryName": "Paraguay", "countryFlagName": "VV-PY", "countryCode": "+595", "letterCode": "PY"],
            ["countryName": "Peru", "countryFlagName": "VV-PE", "countryCode": "+51", "letterCode": "PE"],
            ["countryName": "Philippines", "countryFlagName": "VV-PH", "countryCode": "+63", "letterCode": "PH"],
            ["countryName": "Poland", "countryFlagName": "VV-PL", "countryCode": "+48", "letterCode": "PL"],
            ["countryName": "Portugal", "countryFlagName": "VV-PT", "countryCode": "+351", "letterCode": "PT"],
            ["countryName": "Puerto Rico", "countryFlagName": "VV-PR", "countryCode": "+1787", "letterCode": "PR"],
            ["countryName": "Reunion", "countryFlagName": "VV-RE", "countryCode": "+262", "letterCode": "RE"],
            ["countryName": "Romania", "countryFlagName": "VV-RO", "countryCode": "+40", "letterCode": "RO"],
            ["countryName": "Russia", "countryFlagName": "VV-RU", "countryCode": "+7", "letterCode": "RU"],
            ["countryName": "Saint Lueia", "countryFlagName": "VV-LC", "countryCode": "+1758", "letterCode": "LC"],
            ["countryName": "Saint Vincent", "countryFlagName": "VV-VC", "countryCode": "+1784", "letterCode": "VC"],
            ["countryName": "Samoa Eastern", "countryFlagName": "VV-AS", "countryCode": "+684", "letterCode": "AS"],
            ["countryName": "Samoa Western", "countryFlagName": "VV-WS", "countryCode": "+685", "letterCode": "WS"],
            ["countryName": "San Marino", "countryFlagName": "VV-SM", "countryCode": "+378", "letterCode": "SM"],
            ["countryName": "Sao Tome and Principe", "countryFlagName": "VV-ST", "countryCode": "+239", "letterCode": "ST"],
            ["countryName": "Senegal", "countryFlagName": "VV-SN", "countryCode": "+221", "letterCode": "SN"],
            ["countryName": "Seychelles", "countryFlagName": "VV-SC", "countryCode": "+248", "letterCode": "SC"],
            ["countryName": "Sierra Leone", "countryFlagName": "VV-SL", "countryCode": "+232", "letterCode": "SL"],
            ["countryName": "Singapore", "countryFlagName": "VV-SG", "countryCode": "+65", "letterCode": "SG"],
            ["countryName": "Slovakia", "countryFlagName": "VV-SK", "countryCode": "+421", "letterCode": "SK"],
            ["countryName": "Slovenia", "countryFlagName": "VV-SI", "countryCode": "+386", "letterCode": "SI"],
            ["countryName": "Solomon Is", "countryFlagName": "VV-SB", "countryCode": "+677", "letterCode": "SB"],
            ["countryName": "Somali", "countryFlagName": "VV-SO", "countryCode": "+252", "letterCode": "SO"],
            ["countryName": "South Africa", "countryFlagName": "VV-ZA", "countryCode": "+27", "letterCode": "ZA"],
            ["countryName": "South Sudan", "countryFlagName": "VV-SS", "countryCode": "+211", "letterCode": "SS"],
            ["countryName": "Spain", "countryFlagName": "VV-ES", "countryCode": "+34", "letterCode": "ES"],
            ["countryName": "Sri Lanka", "countryFlagName": "VV-LK", "countryCode": "+94", "letterCode": "LK"],
            ["countryName": "St.Lucia", "countryFlagName": "VV-LC", "countryCode": "+1758", "letterCode": "LC"],
            ["countryName": "St.Vincent", "countryFlagName": "VV-VC", "countryCode": "+1784", "letterCode": "VC"],
            ["countryName": "Sudan", "countryFlagName": "VV-SD", "countryCode": "+249", "letterCode": "SD"],
            ["countryName": "Suriname", "countryFlagName": "VV-SR", "countryCode": "+597", "letterCode": "SR"],
            ["countryName": "Swaziland", "countryFlagName": "VV-SZ", "countryCode": "+268", "letterCode": "SZ"],
            ["countryName": "Sweden", "countryFlagName": "VV-SE", "countryCode": "+46", "letterCode": "SE"],
            ["countryName": "Switzerland", "countryFlagName": "VV-CH", "countryCode": "+41", "letterCode": "CH"],
            ["countryName": "Syria", "countryFlagName": "VV-SY", "countryCode": "+963", "letterCode": "SY"],
            ["countryName": "Taiwan", "countryFlagName": "VV-TW", "countryCode": "+886", "letterCode": "TW"],
            ["countryName": "Tajikstan", "countryFlagName": "VV-TJ", "countryCode": "+992", "letterCode": "TJ"],
            ["countryName": "Tanzania", "countryFlagName": "VV-TZ", "countryCode": "+255", "letterCode": "TZ"],
            ["countryName": "Thailand", "countryFlagName": "VV-TH", "countryCode": "+66", "letterCode": "TH"],
            ["countryName": "Togo", "countryFlagName": "VV-TG", "countryCode": "+228", "letterCode": "TG"],
            ["countryName": "Tonga", "countryFlagName": "VV-TO", "countryCode": "+676", "letterCode": "TO"],
            ["countryName": "Trinidad and Tobago", "countryFlagName": "VV-TT", "countryCode": "+1809", "letterCode": "TT"],
            ["countryName": "Tunisia", "countryFlagName": "VV-TN", "countryCode": "+216", "letterCode": "TN"],
            ["countryName": "Turkey", "countryFlagName": "VV-TR", "countryCode": "+90", "letterCode": "TR"],
            ["countryName": "Turkmenistan", "countryFlagName": "VV-TM", "countryCode": "+993", "letterCode": "TM"],
            ["countryName": "Uganda", "countryFlagName": "VV-UG", "countryCode": "+256", "letterCode": "UG"],
            ["countryName": "Ukraine", "countryFlagName": "VV-UA", "countryCode": "+380", "letterCode": "UA"],
            ["countryName": "Uruguay", "countryFlagName": "VV-UY", "countryCode": "+598", "letterCode": "UY"],
            ["countryName": "Uzbekistan", "countryFlagName": "VV-UZ", "countryCode": "+233", "letterCode": "UZ"],
            ["countryName": "Venezuela", "countryFlagName": "VV-VE", "countryCode": "+58", "letterCode": "VE"],
            ["countryName": "Vietnam", "countryFlagName": "VV-VN", "countryCode": "+84", "letterCode": "VN"],
            ["countryName": "Yemen", "countryFlagName": "VV-YE", "countryCode": "+967", "letterCode": "YE"],
            ["countryName": "Zambia", "countryFlagName": "VV-ZM", "countryCode": "+260", "letterCode": "ZM"],
            ["countryName": "Zimbabwe", "countryFlagName": "VV-ZW", "countryCode": "+263", "letterCode": "ZW"],
        ]
        
        
        return countryArray
        
    }

    
}
