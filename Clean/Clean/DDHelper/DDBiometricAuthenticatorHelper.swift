import UIKit
import BiometricAuthentication

@objcMembers class DDBiometricAuthenticatorHelper: NSObject {

    
    class func isFaceIdDevice() -> Bool {
        
        return BioMetricAuthenticator.shared.faceIDAvailable()
        
    }
    
    class func isTouchIDDevice() -> Bool {

        return BioMetricAuthenticator.shared.touchIDAvailable()
        
    }
    
    class func canAuthenticate() -> Bool {
        
        return BioMetricAuthenticator.canAuthenticate()
        
    }

    class func authenticateWithBioMetrics(completion: @escaping (Bool) -> Void) {
        
        BioMetricAuthenticator.shared.allowableReuseDuration = 10
        
        // start authentication
        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "") { (result) in
                
            switch result {
            case .success( _):
                completion(true)
            case .failure(let error):
                
                
                switch error {
                // device does not support biometric (face id or touch id) authentication
                case .biometryNotAvailable:
                    
                    JRToast.show(withText: error.message(), bottomOffset: 400)
                    completion(false)

                    
                // No biometry enrolled in this device, ask user to register fingerprint or face
                case .biometryNotEnrolled:
                    self.showGotoSettingsAlert(message: error.message())
                // show alternatives on fallback button clicked
                    completion(false)

                case .biometryLockedout:
                    
                    self.showPasscodeAuthentication(message: error.message()) { success in
                        completion(success)
                    }
                    
                // do nothing on canceled by system or user
                case .canceledBySystem, .canceledByUser:
                    completion(false)

                    break
                    
                // show error for any other reason
                default:
                    
                    JRToast.show(withText: error.message(), bottomOffset: 400)
                    completion(false)

                }
            }
        }

        
        
    }
    
    
    class func showPasscodeAuthentication(message: String, completion: @escaping (Bool) -> Void) {
        
        BioMetricAuthenticator.authenticateWithPasscode(reason: message) { result in
            switch result {
                
            case .success( _):

                
                completion(true)
                
                
            case .failure(_):
                
                completion(false)

            }
        }
    }
    
    class func showGotoSettingsAlert(message: String) {
        
        let sureAction = UIAlertAction(title: DDlocal("DDGo_to_Settings"), style: .default) { action in
            // open settings
            let url = URL(string: UIApplication.openSettingsURLString)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:])
            }
        }
        
        let alertVC = UIAlertController(title: DDlocal("DDError"), message: message, preferredStyle: .alert)
        
        alertVC.addAction(sureAction)
        
        if let vc = DDSharePreferences.getCurrentController() {
            vc.present(alertVC, animated: true, completion: nil)
        }
        
        
        
    }
}
