import UIKit

class DDSettingsController: UIViewController {

    private let faceIDSwitch = UISwitch()
    private let removeAfterAlbumSwitch = UISwitch()
    private let removeAfterContactsSwitch = UISwitch()

    override func loadView() {
        let rootView = UIView()
        rootView.backgroundColor = UIColor(hexString: "#F8F8F8")
        view = rootView

        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.text = DDlocal("DDSettings")

        let sectionLabel = UILabel()
        sectionLabel.font = .systemFont(ofSize: 14)
        sectionLabel.text = DDlocal("DDPRIVACY_SETTINGS")

        let faceIDTitle: String
        if DDBiometricAuthenticatorHelper.isTouchIDDevice() {
            faceIDTitle = "Touch ID"
        } else {
            faceIDTitle = "Face ID"
        }

        let stackView = UIStackView(arrangedSubviews: [
            sectionLabel,
            makeSwitchRow(title: faceIDTitle, toggle: faceIDSwitch, selector: #selector(faceIDSwitchChanged(_:))),
            makeSwitchRow(title: DDlocal("DDRemove_After_Import_Album"), toggle: removeAfterAlbumSwitch, selector: #selector(removeAfterAlbumSwitchChanged(_:))),
            makeSwitchRow(title: DDlocal("DDRemove_After_Import_Contacts"), toggle: removeAfterContactsSwitch, selector: #selector(removeAfterContactsSwitchChanged(_:)))
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true

        rootView.addSubview(titleLabel)
        rootView.addSubview(stackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 44),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -16)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fd_prefersNavigationBarHidden = true
        faceIDSwitch.setOn(DDSharePreferences.openPrivacyLock, animated: false)
        removeAfterAlbumSwitch.setOn(DDSharePreferences.secretAlbumRemoveOriginalPhotos, animated: false)
        removeAfterContactsSwitch.setOn(DDSharePreferences.secretContactsRemoveOriginalContacts, animated: false)
    }

    private func makeSwitchRow(title: String, toggle: UISwitch, selector: Selector) -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 10
        container.heightAnchor.constraint(equalToConstant: 54).isActive = true

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: selector, for: .valueChanged)

        container.addSubview(label)
        container.addSubview(toggle)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: toggle.leadingAnchor, constant: -10),
            toggle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),
            toggle.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        return container
    }

    @objc private func faceIDSwitchChanged(_ sender: UISwitch) {
        DDBiometricAuthenticatorHelper.authenticateWithBioMetrics { success in
            if success {
                DDSharePreferences.openPrivacyLock = sender.isOn
                DDshowDelayToast(DDlocal("DDSuccess"), 0.5)
            } else {
                sender.setOn(DDSharePreferences.openPrivacyLock, animated: true)
                DDshowDelayToast(DDlocal("DDFail"), 0.5)
            }
        }
    }

    @objc private func removeAfterAlbumSwitchChanged(_ sender: UISwitch) {
        DDSharePreferences.secretAlbumRemoveOriginalPhotos = sender.isOn
    }

    @objc private func removeAfterContactsSwitchChanged(_ sender: UISwitch) {
        DDSharePreferences.secretContactsRemoveOriginalContacts = sender.isOn
    }
}
