# Building and Running Square Color Game

## Prerequisites
- macOS 12.0 or later
- Xcode 14.0 or later
- iOS 16.0+ device or simulator

## Building with Xcode

Since this is a SwiftUI app that requires Apple's iOS SDK, it must be built using Xcode on macOS.

### Option 1: Create Xcode Project from Package

1. Open Xcode
2. File → Open → Select the `SquareColorGame` folder
3. Xcode will recognize the Package.swift and open it as a project
4. Select your target device/simulator
5. Press ⌘R to build and run

### Option 2: Manual Xcode Project Creation

If you need to create a traditional Xcode project:

1. Open Xcode
2. Create a new iOS App project
3. Name it "SquareColorGame"
4. Choose SwiftUI for Interface
5. Set deployment target to iOS 16.0
6. Copy all source files maintaining the folder structure:
   - Copy `SquareColorGame/App/` files to your project
   - Copy `SquareColorGame/Models/` files to your project
   - Copy `SquareColorGame/ViewModels/` files to your project
   - Copy `SquareColorGame/Views/` files to your project
   - Copy `SquareColorGame/Utilities/` files to your project
7. Build and run (⌘R)

## Project Configuration

### Bundle Identifier
Set a unique bundle identifier in your project settings, for example:
```
com.yourcompany.SquareColorGame
```

### Deployment Target
- Minimum: iOS 16.0
- Recommended: iOS 16.0+

### Required Capabilities
No special capabilities or entitlements are required. The app uses:
- SwiftUI (built-in)
- Combine (built-in)
- UserDefaults (built-in)
- UIKit for haptics (built-in)

## Troubleshooting

### "No such module 'SwiftUI'" Error
This occurs when trying to build on Linux or without iOS SDK. You must build on macOS with Xcode.

### Module Import Issues
Make sure all files are added to your Xcode target:
1. Select each .swift file in Xcode
2. Check the "Target Membership" in the File Inspector
3. Ensure "SquareColorGame" target is checked

### Preview Issues
If SwiftUI previews don't work:
1. Clean build folder (⌘⇧K)
2. Restart Xcode
3. Ensure you're on macOS 12.0+ with Xcode 14.0+

## Testing on Simulator

Recommended simulators:
- iPhone 14 Pro (iOS 16.0+)
- iPhone 15 (iOS 17.0+)
- iPad Pro 12.9" (iOS 16.0+)

To test:
1. Select simulator from device menu
2. Build and run (⌘R)
3. The app will launch in the simulator

## Testing on Physical Device

1. Connect your iOS device
2. Select it from the device menu
3. You may need to configure signing:
   - Go to project settings → Signing & Capabilities
   - Select your Apple ID team
   - Enable "Automatically manage signing"
4. Build and run (⌘R)

## Performance Notes

The game uses:
- Combine for timer updates (0.1s intervals)
- UserDefaults for persistence (lightweight)
- SwiftUI animations (hardware accelerated)
- Haptic feedback (iOS device only)

Expected performance:
- Smooth 60fps animations
- Instant color generation
- No noticeable lag in gameplay
