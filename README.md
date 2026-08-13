# Clean

Clean is a UIKit-based iOS utility for reviewing photos, videos, contacts, and calendar events before removing unwanted items. It also includes local private-album and private-contact features protected by supported device biometrics.

## Features

- Summarize available device storage and review cleanable categories.
- Find similar, duplicate, blurry, and screenshot photos.
- Find duplicate, short, and screen-recording videos.
- Review duplicate or incomplete contacts and merge selected duplicates.
- Find and remove selected historical calendar events.
- Import selected photos and videos into a private album.
- Import selected contacts into a private contact list.
- Optionally remove source items after a private import.
- Protect private content with supported device biometrics.
- Use the interface in English or French.

## Technology

- Swift 5 and UIKit
- PhotoKit, Contacts, EventKit, and LocalAuthentication-related functionality
- XIBs and storyboards
- OpenCV-based image analysis
- SQLite persistence through FMDB
- CocoaPods dependency management

Direct CocoaPods dependencies are listed in the `Podfile`:

- BiometricAuthentication
- FMDB
- IQKeyboardManager
- OpenCV2
- SVProgressHUD

The source tree also contains bundled third-party UI components. Their original notices and license terms must be preserved.

## Requirements

- macOS with Xcode
- CocoaPods
- iOS 13.0 or later, as configured for the application target
- A physical iOS device with representative media, contacts, and calendar data is recommended for full testing

The checked-in lockfile was generated with CocoaPods 1.16.2. Using the lockfile helps preserve the currently resolved dependency versions.

## Getting Started

1. From the repository root, change to the Xcode project directory:

   ```sh
   cd gil-cleanapp-ios/Clean
   ```

2. Install the CocoaPods dependencies:

   ```sh
   pod install
   ```

3. Open `Clean.xcworkspace` in Xcode. Do not open the `.xcodeproj` when building with CocoaPods.
4. Select the `Clean` scheme.
5. Configure a development team and a unique bundle identifier for your environment.
6. Build and run the application.

## Permissions

The application requests access according to the feature being used:

- Photo library read access for media analysis and private-album imports.
- Photo library add access for exporting media from the private album.
- Contacts access for duplicate detection, cleanup, and private contacts.
- Calendar access for finding and removing selected historical events.
- Face ID access for protecting private albums and contacts.

The application must remain usable when a permission is denied, limited, or later revoked.

## Data-Loss Warning

Cleanup actions can delete photos, videos, contacts, or calendar events. Contact merges may also remove records and may not be reversible. Before testing:

- Use non-production sample data whenever possible.
- Keep an independent backup of important data.
- Review every selection before confirming a cleanup action.
- Verify the behavior of the “Remove After Import” settings before importing private content.
- Remember that deleted media may continue to occupy storage until the system's Recently Deleted album is emptied.

## Privacy and Production Readiness

Private content is still sensitive local application data. Review file protection, database storage, backups, exports, logging, screenshots, and biometric fallback behavior before production use. This repository is an application project, not a privacy or security audit.

## Project Layout

```text
Clean/
├── Clean.xcworkspace
├── Clean.xcodeproj
├── Clean/
│   ├── Main/
│   │   ├── Clean/            # Media, contact, and calendar cleanup
│   │   ├── Privacy/          # Private album and contacts
│   │   └── Settings/
│   ├── DDHelper/             # Data access, persistence, and shared helpers
│   ├── DDResource/           # Localization and application resources
│   └── Info.plist
├── Podfile
└── Podfile.lock
```

## Validation

No automated test target is included. Before distributing a build, test each cleanup category with controlled data, all permission states, private import/export, biometric protection, application relaunch, and recovery from interrupted analysis or deletion operations.

Third-party libraries and bundled third-party source files remain subject to their respective licenses and attribution requirements.
